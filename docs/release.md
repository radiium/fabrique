# Publication

L'app se publie sur Android, visée F-Droid, et sur le web. Pas d'iOS : voir [ui/principles.md](ui/principles.md).

## Version

`version: X.Y.Z+N` dans `pubspec.yaml` : Gradle en tire `versionName` (`X.Y.Z`, ce que l'utilisateur voit) et `versionCode` (`N`).

- **`N` ne fait que monter**, de 1 à chaque version publiée. Android refuse une mise à jour dont le `versionCode` n'est pas plus grand.
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
