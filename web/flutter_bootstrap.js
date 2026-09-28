{{flutter_js}}
{{flutter_build_config}}

// Sans `serviceWorkerSettings` : le service worker de Flutter se désinscrit
// lui-même, et il remplacerait `sw.js` à la même portée.
_flutter.loader.load({
  onEntrypointLoaded: async (engineInitializer) => {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
    registerOfflineWorker();
  },
});

// Inscrit `sw.js` une fois l'app lancée, pour ne pas ralentir le premier
// affichage.
function registerOfflineWorker() {
  if (!('serviceWorker' in navigator)) return;
  const { serviceWorker } = navigator;
  // La page vient de passer sous son contrôle : ce qu'elle a chargé avant lui
  // échappe au cache, on le lui envoie.
  serviceWorker.addEventListener('controllerchange', () => {
    const urls = performance
      .getEntriesByType('resource')
      .map((entry) => entry.name);
    serviceWorker.controller?.postMessage({
      type: 'precache',
      urls: [location.href.split('#')[0], ...urls],
    });
  });
  serviceWorker.register('sw.js').catch((error) => {
    console.warn('Fabrique : service worker non inscrit', error);
  });
}
