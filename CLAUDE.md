# CLAUDE.md

**Fabrique**: five calculation tools for the shop (Calepinage, Répartition, Tiroirs, Niveau, Convertisseur), on Android and Web.

## Documentation

`docs/` is the reference: follow it rather than inventing a structure, and update it in the same commit as a decision that changes. [`docs/README.md`](docs/README.md) says what to read before touching what. In short:

- a tool → `docs/tools/<tool>.md` (same name as `lib/features/<tool>/`)
- a painter, the drawing export → `docs/drawing.md`
- a control, a screen → `docs/ui.md`
- persistence, a dependency, the language → `docs/architecture.md`
- the version, signing → `docs/release.md`

`docs/` only keeps what the code cannot say (business rule, rejected option, procedure): neither what can be read in the code nor what applies to the whole app. Each file opens with a table of contents. `docs/` is written in French.

## Commands

```bash
flutter run                  # -d chrome for the web
flutter test
dart run build_runner build  # after any @freezed / @riverpod change
flutter gen-l10n             # after editing lib/l10n/app_*.arb
```

Before handing back: `dart fix --apply`, `dart format lib test`, clean `flutter analyze`, green `flutter test`.

Flutter 3.47 / Dart 3.13. Generated code (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_localizations*.dart`) is never edited by hand.

## Known pitfalls

- `riverpod_lint` / `custom_lint` are deliberately absent: they do not resolve with Riverpod 3.4 + `freezed_annotation` 3.x.
- Riverpod 3: a generated function provider takes a plain `Ref`, and `AsyncValue` exposes `.value` (no `valueOrNull`).

## Non-negotiable conventions

- **The painter paints, the core computes.** No math in rendering.
- **`lib/core/calc` never imports Flutter**: that is what makes it testable without a device.
- **Everything is in millimetres** (`double`). Conversions only at the UI boundaries.
- **Invalid input throws `CalcException`**, never a wrong value. It carries a typed reason (`CalcError`) with its figures, and the UI words it in the app language (`l10n.calcError`).
- **`@freezed` models, `@riverpod` providers.** A tool's result is a provider derived from its input: no `setState` in the calculation, no "calculate" button. `setState` remains allowed for local UI state (rotation, export in progress).
- **A tool feature**: `*_screen`, `*_controller`, `*_schema` (the only place the painter is built), `*_painter`. Anything else only if needed.
- **Shop use**: targets ≥ 48 px (`kFieldHeight`), no label silently truncated. The drawing may fall below the fold: a rich tool does not fit on one screen.
- **All read text goes through `AppLocalizations`**, in French and English, painters and exported drawing included. A key added is added to both ARB files (a test compares them). A displayed number goes through `l10n.number`, for the decimal separator. `core/` carries no text: its enums are named by an extension on the UI side.
- **Read text uses the screen's word**: a dimension has the same name in its field, its help and its refusals. In an explanation (help, refusal), no em dash and no semicolon: two sentences, a colon or parentheses. The dash stays where it separates visually (`Surface — largeur`, drawing legend).

## Code rules

`analysis_options.yaml` enforces strict mode and lints on top of `flutter_lints`. What follows, the analyzer does not check.

### Dart

- **No `_` wildcard in a `switch` over an enum or sealed class.** An added case must break compilation, not slip through silently. The wildcard remains allowed on value ranges (`>= 100 =>`).
- **A table that must cover a whole enum is a `switch`, not a `Map`**, for the same reason.
- **No `!` without a guarantee.** Prefer a pattern (`if (x case final v?)`, `AsyncData(:final value)`). A remaining `!` says why it is safe.
- **Typed `catch`.** A broad `catch` only at a system boundary (export, storage), and the failure is never silent: `debugPrint` or an on-screen message.
- **Naming**: a boolean reads as a question (`isCut`), a module constant takes the `k` prefix, a private one `_`.

### Flutter

- **Widget classes, not `_buildX()` methods**: that is what allows `const` and targeted rebuilds.
- **A screen over ~400 lines gets split**, one file per component (`distribution_positions_table.dart`).
- **A widget duplicated across two features moves up to `core/widgets`.**
- **Theme tokens only** (`AppColors`, `AppSpacing`, `AppRadii`): a hard-coded color ends up drifting from the theme. A number that carries a decision (margin, threshold, size) is a named constant. An obvious `2` stays inline.
- **`ref.watch` in `build`, `ref.read` in callbacks**: a `read` in `build` misses updates, and Riverpod does not support a `watch` outside `build`. Exception: `ref.read(….notifier)` in `build`, to wire field methods.
- **Every controller or `Timer` created is disposed** (`dispose`, `ref.onDispose`).
- **Every `IconButton` has a `tooltip`**: it is its label for a screen reader, and its tooltip on the web.

### Architecture

- **A feature never imports another feature**, only `core/` and `app/`. Exception: `features/schema/`, which dispatches to each tool's drawing.
- **A path is built through `AppRoutes`** (`app/routes.dart`), never hard-coded: a typo in a route only breaks at runtime.
- **No new dependency without its justification in `docs/architecture.md`**: why it, and why not the SDK.

### Tests

- **A test mirrors the path of the file under test** (`lib/core/calc/layout.dart` → `test/core/calc/layout_test.dart`). Cross-cutting tests (reset, persistence, haptics) live at the root of `test/features/`.
- **Every painter has a "renders without throwing" test**: three sizes (thumbnail, full screen, degenerate canvas) and a refused input. A painter that throws only shows up at render time.
- **A screen test mounts on the reference phone** (`usePhone`, `test/support/phone.dart`): truncated labels are measured on it.
- **A test's name describes a behavior**, in French. It is its comment.

### Commits

In French, in the format `Portée : description` (`Calepinage : …`, `Docs : …`).

## Comments

In French. A comment says what the code cannot say: a unit, a bound, a business constraint, a verified pitfall. If it can be guessed by reading the code, it does not exist. Never how the code evolved: that is git's job.

**Length**
- One line by default. At most three for a `///` (excluding the list of cases that throw `CalcException`), two for a `//`. A decision that needs more goes in `docs/`, not in the code.
- A reason, not a plea: no rejected alternatives, no defense of the choice. Only exception: "don't do X" when X is the tempting but wrong fix, in one sentence.

**Tone**: that of a technical manual.
- Simple declarative sentences. No maxims, no stock phrases (« c'est tout l'intérêt », « c'est voulu », « d'où »), no personification (a label does not « mentir », a value does not « parler »).
- No bold, no ⚠️: emphasis does not replace clarity.

**Form**
- `///` on types, public APIs and anything that carries a decision. Not on a field whose name says it all (`final Widget child;`). `//` for a subtlety inside a body.
- First line: a self-contained sentence, starting with a verb (« Répartit… ») or a noun (« Vue de dessus : … »). If more is needed, a blank line, then the explanation.
- Symbols in brackets: `[computeDistribution]`.
- `// TODO(scope):` only for what is listed in `docs/roadmap.md`.
- Em dash and semicolon are allowed here: the punctuation rule targets app text.

**By layer**
- `core/calc`: the unit, the bounds, what throws `CalcException`. This dartdoc is what the screens read.
- Painters: a drawing order or a threshold, never geometry (it lives in `core`).
- Shared widgets: heights and theme values, especially pitfalls verified by measurement.
- Tests: a magic number or a safeguard, in one line. The test name says the rest.

**To remove**: paraphrase, commented-out code, comments that became false, decorative separators, any reference to a document (`docs/` included: a document moves, the comment stays and becomes false), and history, even disguised: « n'avait pas », « ne … plus », « avant », a comparison with a former value.

A comment pass never touches logic. When in doubt, shorten.
