'use strict';

// Service worker hors ligne : réseau d'abord, cache en repli.
//
// Le cache d'abord ferait tourner l'ancienne version un lancement de plus, et
// mélangerait deux builds si un fichier manquait.

const kCache = 'fabrique';

// Polices Noto que le moteur télécharge pour un glyphe absent de Roboto.
const kFontsOrigin = 'https://fonts.gstatic.com';

self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

function isCacheable(url) {
  const { origin } = new URL(url);
  return origin === self.location.origin || origin === kFontsOrigin;
}

// Fichiers du moteur chargés à la demande : licences, polices, shaders de
// l'étirement Android. Un fichier absent de ce build est ignoré.
const kFlutterFiles = [
  'assets/AssetManifest.bin.json',
  'assets/FontManifest.json',
  'assets/NOTICES',
  'assets/shaders/ink_sparkle.frag',
  'assets/shaders/stretch_effect.frag',
];

// Les fichiers chargés avant que ce worker ne contrôle la page, envoyés par
// `flutter_bootstrap.js`, plus ceux chargés à la demande : sans eux, un écran
// ouvert pour la première fois hors ligne échoue.
self.addEventListener('message', (event) => {
  if (event.data?.type !== 'precache') return;
  event.waitUntil(precache(event.data.urls));
});

async function precache(loadedUrls) {
  const cache = await caches.open(kCache);
  const urls = [...loadedUrls, ...kFlutterFiles, ...(await declaredAssets())]
    .map((url) => new URL(url, self.registration.scope).href)
    .filter(isCacheable);
  await Promise.all(
    [...new Set(urls)].map((url) =>
      cache.add(url).catch((error) => {
        console.warn(`Fabrique : ${url} non mis en cache`, error);
      }),
    ),
  );
}

// Les assets du `pubspec`, lus dans `AssetManifest.bin.json`.
async function declaredAssets() {
  try {
    const response = await fetch('assets/AssetManifest.bin.json');
    const keys = decodeStandardMessage(await response.json());
    return keys.map((key) => `assets/${encodeURI(key)}`);
  } catch (error) {
    console.warn('Fabrique : manifeste des assets illisible', error);
    return [];
  }
}

// Décode du `StandardMessageCodec` en base64, et rend les clés de la map
// racine. Seuls les types du manifeste sont lus.
function decodeStandardMessage(base64) {
  const bytes = Uint8Array.from(atob(base64), (c) => c.charCodeAt(0));
  const view = new DataView(bytes.buffer);
  const utf8 = new TextDecoder();
  let pos = 0;
  const readSize = () => {
    const byte = bytes[pos++];
    if (byte < 254) return byte;
    const width = byte === 254 ? 2 : 4;
    const size =
      width === 2 ? view.getUint16(pos, true) : view.getUint32(pos, true);
    pos += width;
    return size;
  };
  const read = () => {
    const type = bytes[pos++];
    switch (type) {
      case 0: // null
      case 1: // true
      case 2: // false
        return null;
      case 3: // int32
        pos += 4;
        return null;
      case 4: // int64
        pos += 8;
        return null;
      case 6: // float64, aligné sur 8 octets depuis le début du message
        pos += (8 - (pos % 8)) % 8;
        pos += 8;
        return null;
      case 7: {
        const length = readSize();
        const text = utf8.decode(bytes.subarray(pos, pos + length));
        pos += length;
        return text;
      }
      case 12: {
        const length = readSize();
        for (let i = 0; i < length; i++) read();
        return null;
      }
      case 13: {
        const length = readSize();
        const keys = [];
        for (let i = 0; i < length; i++) {
          keys.push(read());
          read();
        }
        return keys;
      }
      default:
        throw new Error(`type ${type} inattendu`);
    }
  };
  return read();
}

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET' || !isCacheable(request.url)) return;
  event.respondWith(networkFirst(event));
});

async function networkFirst(event) {
  const { request } = event;
  const cache = await caches.open(kCache);
  try {
    const response = await fetch(request);
    // 200 seulement : le cache refuse une réponse partielle (206).
    if (response.status === 200) {
      event.waitUntil(cache.put(request, response.clone()));
    }
    return response;
  } catch (error) {
    // Les routes sont dans le fragment (`#/tool/…`) : toute navigation sert
    // la page d'entrée.
    const cached =
      (await cache.match(request)) ??
      (request.mode === 'navigate'
        ? await cache.match(self.registration.scope)
        : undefined);
    if (cached) return cached;
    throw error;
  }
}
