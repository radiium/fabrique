# Publication

L'app se publie sur Android, visée F-Droid, et sur le web. Pas d'app iOS : sans équivalent de F-Droid, elle n'y serait distribuable que par l'App Store. Sur iPhone comme sur ordinateur, le web s'installe (« Sur l'écran d'accueil », « Installer l'app ») et marche hors ligne.

- [Version](#version)
- [Signature](#signature)
- [Vérifier un APK](#vérifier-un-apk)
- [Fiche F-Droid](#fiche-f-droid)
- [Web](#web)
- [Intégration continue](#intégration-continue)

## Version

`version: X.Y.Z+N` dans `pubspec.yaml` : Gradle en tire `versionName` (`X.Y.Z`, ce que l'utilisateur voit) et `versionCode` (`N`).

- **`N` ne fait que monter**, de 1 à chaque version publiée. Android refuse une mise à jour dont le `versionCode` n'est pas plus grand.
- **`X.Y.Z` se recopie dans `kAppVersion`** (`lib/app/version.dart`), affiché par les Réglages et « À propos ». Un test compare les deux. Pas de `package_info_plus` : sur le web, il lit `version.json` avec un paramètre anti-cache, que le service worker ne retrouve pas hors ligne.
- **Un tag `vX.Y.Z` par version**, posé sur le commit qui change le `pubspec`. F-Droid détecte les nouvelles versions par ces tags.

## Signature

- **La clé de release ne vit pas dans le dépôt.** `android/key.properties` pointe vers elle, et le `.gitignore` d'`android/` écarte ce fichier, les `.jks` et les `.keystore`.
- **Sans `key.properties`, l'APK de release sort non signé.** C'est ce qu'attend F-Droid, qui compile depuis les sources et signe avec sa propre clé. Pas de repli sur la clé de debug : un APK signé par elle partirait un jour par erreur.
- ⚠️ **Perdre la clé, c'est ne plus pouvoir publier de mise à jour** : Android refuse de remplacer une app signée par une autre clé. Elle se sauvegarde hors de la machine, avec ses mots de passe.

Créer la clé, une seule fois :

```bash
keytool -genkeypair -v -keystore ~/keys/fabrique-release.jks \
  -keyalg RSA -keysize 4096 -validity 10000 -alias fabrique
```

Puis `android/key.properties` :

```properties
storeFile=/Users/<vous>/keys/fabrique-release.jks
storePassword=…
keyAlias=fabrique
keyPassword=…
```

`storeFile` absolu, ou relatif à `android/app/`.

## Vérifier un APK

```bash
flutter build apk --release
apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk
```

## Fiche F-Droid

`fastlane/metadata/android/fr-FR/` et `en-US/` : F-Droid et IzzyOnDroid y lisent la fiche de l'app, à chaque version.

- **Français et anglais**, comme l'app. Les deux fiches disent la même chose ; un changement de l'une se reporte dans l'autre, changelogs compris. F-Droid prend `en-US` quand la langue du téléphone manque.
- `title.txt` : le nom affiché par l'app. `short_description.txt` : 80 caractères au plus. `full_description.txt` : 4000 au plus, quelques balises HTML (`<b>`, `<i>`, `<ul>`) permises.
- **Un changelog par version**, `changelogs/<versionCode>.txt`, 500 caractères au plus, écrit dans le commit qui monte la version.
- **« Aucun accès à Internet » est une promesse** : l'APK ne demande pas la permission `INTERNET`. Une dépendance qui l'ajouterait oblige à réécrire la description.
- Captures, s'il y en a : `images/phoneScreenshots/1.png`, `2.png`… L'icône, F-Droid la tire de l'APK.

## Web

```bash
flutter build web --no-web-resources-cdn
```

- **`--no-web-resources-cdn` est obligatoire.** Sans lui, CanvasKit vient de `www.gstatic.com`, que le service worker ne met pas en cache : l'app ne démarre plus hors ligne.
- **Le service worker est le nôtre** (`web/sw.js`). Celui de Flutter est déprécié et se désinscrit lui-même : `web/flutter_bootstrap.js` ne le charge pas.
- **Réseau d'abord, cache en repli.** En ligne, l'app est toujours la dernière version, d'un seul tenant. Le cache d'abord ferait tourner l'ancienne un lancement de plus.
- **Au premier lancement, tout ce qu'un écran peut charger est mis en cache** : les fichiers déjà chargés, les assets du `pubspec` et les fichiers du moteur chargés à la demande (licences, shaders), listés dans `sw.js`.
- **Le hors ligne suppose un premier lancement en ligne.** Une police de glyphe rare (Noto) n'est en cache que si elle a déjà servi.
- **Pas d'orientation imposée dans le manifeste** : installée, l'app bloquerait le paysage du schéma plein écran.
- Vérifier, et refaire après chaque montée de Flutter (la liste du moteur le suit) : servir `build/web` en local, DevTools › Application (manifeste sans erreur, `sw.js` actif), puis **arrêter le serveur** et ouvrir chaque écran, « À propos » et ses licences compris. La case « Offline » du panneau Network ne coupe pas les requêtes du service worker : elle masque un fichier manquant.

## Intégration continue

`.github/workflows/ci.yml`, à chaque push et pull request : `flutter analyze`, `flutter test`, puis le build web. Sur `main`, ce build part sur GitHub Pages.

- **Servi sous `/fabrique/`**, d'où `--base-href /fabrique/`. Les routes vivent dans le fragment (`#/…`) : pas de `404.html` à prévoir.
- **Flutter figé à la version locale** dans le workflow, à monter avec elle : la liste du moteur dans `sw.js` en dépend.
- Une seule fois, dans le dépôt : Settings › Pages › Source : « GitHub Actions ».
