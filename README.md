# Fabrique

Five calculation tools for the woodworking shop, on Android and the web. Results update as you type, with a dimensioned drawing that can be exported as an image.

- **Calepinage** (layout): lay identical pieces on a surface, with cuts and waste %.
- **Répartition** (spacing): distribute pieces across a width, by count or by gap.
- **Tiroirs** (drawers): cut list for boxes and fronts, slide mounting.
- **Niveau** (level): spirit level and inclinometer.
- **Convertisseur** (converter): lengths, areas, volumes, masses and pressures, in shop units.

Everything is in millimetres. No ads, no account, no Internet access.

## Commands

```bash
flutter run                   # -d chrome for the web
flutter test
flutter analyze
dart run build_runner build   # after changing @freezed / @riverpod
flutter gen-l10n              # after changing lib/l10n/app_fr.arb
flutter build apk --release   # signed if android/key.properties exists
flutter build web
```

The documentation is in [`docs/`](docs/README.md) (in French), publishing in [`docs/release.md`](docs/release.md).

## License

Distributed under the [GNU GPL v3 or later](LICENSE) (`GPL-3.0-or-later`).
