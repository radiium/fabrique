# Niveau

Niveau à bulle et inclinomètre, par l'accéléromètre (`sensors_plus`). Aucune saisie.

| Couche | Fichiers |
|---|---|
| Calcul | `lib/core/calc/tilt.dart` · `test/core/calc/tilt_test.dart` |
| Écran | `lib/features/level/` : `_screen`, `_controller` (flux capteur) |
| Schéma | `_schema`, `_painter` |

---

## Règles métier

- **Seule la math vit dans `core/calc`.** Le flux `sensors_plus` et son lissage restent dans `level_controller.dart` : un filtre a une mémoire et dépend de la cadence, `computeTilt` reste une fonction pure d'une seule lecture.
- **Le calibrage « zéro » compte pour la crédibilité** : la précision dépend du capteur du téléphone.

## Calcul

```dart
@freezed
class AccelReading { const factory AccelReading(double x, double y, double z) = _AccelReading; }

@freezed
class TiltResult {
  const factory TiltResult({
    required double pitchDeg, required double rollDeg,
    required bool isLevel,
  }) = _TiltResult;
}

TiltResult computeTilt(AccelReading r, {AccelReading? zero, double levelThresholdDeg = 0.5});
```

- `pitch = atan2(y, √(x² + z²))`, `roll = atan2(x, √(y² + z²))`, en degrés.
- `zero` : ses propres angles sont soustraits.
- `isLevel = |pitch| < seuil && |roll| < seuil`.
- **Refus** : seuil invalide, lecture non finie, vecteur nul (`atan2(0, 0)` rendrait un « à plat » faux). Un capteur qui décroche peut produire les deux : le provider rend alors `null`.

### Cas de test attendus

- À plat `(0, 0, 9,81)` → 0 / 0, à niveau.
- Sur le côté `(9,81, 0, 0)` → roll ≈ 90°. Sur l'avant `(0, 9,81, 0)` → pitch ≈ 90°.
- Lecture égale au zéro → 0 / 0.
- Seuil : 0,4° à niveau, 0,6° hors niveau.

## Flux capteur

- **50 Hz** (`SensorInterval.gameInterval`). Le défaut de `sensors_plus` (200 ms) fait sauter la bulle au lieu de la faire glisser, et un niveau qui saute n'inspire pas confiance.
- **Lissage passe-bas, poids 0,12** : l'accéléromètre est bruité de quelques centièmes de g, et l'angle brut frémit juste au-dessus du seuil de niveau.

## Écran

- **Saisie** : `Mettre à zéro` (inerte tant que le capteur n'a rien livré) et `Annuler` une fois un zéro posé. Sans retour au zéro absolu, un mauvais calibrage ne se rattraperait qu'en redémarrant l'app. Le zéro n'est pas persisté.
- **Capteur indisponible** (navigateur de bureau, émulateur, permission refusée) : on le dit, plutôt que de laisser une bulle figée au centre passer pour un niveau parfait.
- **Résultats** : `Inclinaison latérale` · `Inclinaison longitudinale` (au dixième de degré, `formatDegrees`, `-0` ramené à `0`) · `État` (`À plat` / `Hors niveau`, relatif à l'horizontale ou au zéro posé).
- **Pas de « réinitialiser »** : rien à persister.

## Schéma

La vedette de l'écran : une fiole circulaire, bulle mobile, angles en gros.

- **Circulaire plutôt que tubulaire** : `TiltResult` porte deux axes, un tube n'en montrerait qu'un.
- **La bulle monte du côté haut**, comme dans un vrai niveau, pas comme une bille qui roule. La lecture se transpose à l'outil qu'on a déjà en main.
- **Le contour s'épaissit et prend l'accent à niveau** : le signal se voit du coin de l'œil.
- **Carte non tapable** : pas de détail à aller chercher, et une page par-dessus couperait des yeux le flux du capteur.
- Pas un plan : texte en gris des libellés.

## Décidé / écarté

- **Pas de plan exporté** : un flux capteur figé n'est pas un plan.
