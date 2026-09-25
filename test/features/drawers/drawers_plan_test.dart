import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/drawers.dart';
import 'package:fabrique/core/export/plan.dart';
import 'package:fabrique/features/drawers/drawers_controller.dart';
import 'package:fabrique/features/drawers/drawers_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PlanPainter? planOf(DrawersInput input) {
    DrawersOutcome outcome;
    try {
      outcome = DrawersReady(computeDrawers(input));
    } on CalcException catch (e) {
      outcome = DrawersFailure(e.message);
    }
    return buildDrawersPlan(
      input: input,
      outcome: outcome,
      date: DateTime(2026, 9, 26),
    );
  }

  test('une saisie refusée ne fait pas de plan', () {
    expect(planOf(kDrawersDefaults.copyWith(openingWidth: 50)), isNull);
  });

  test('la fiche de débit et les axes passent en entier', () {
    final plan = planOf(kDrawersDefaults)!.plan;
    final result = computeDrawers(kDrawersDefaults);
    final [cutList, axes] = plan.tables;

    expect(cutList.rows, hasLength(result.cutList.length));
    expect(axes.rows, hasLength(kDrawersDefaults.drawerCount));
    for (final table in plan.tables) {
      expect(
        table.rows.every((row) => row.length == table.headers.length),
        isTrue,
        reason: table.title,
      );
    }
  });

  test('bois sur bois : pas de longueur de glissière', () {
    final labels = planOf(
      kDrawersDefaults.copyWith(slide: SlideKind.woodOnWood),
    )!.plan.fields.map((f) => f.$1);

    expect(labels, contains('GLISSIÈRE'));
    expect(labels, isNot(contains('LONGUEUR')));
  });

  test('seule la glissière sous tiroir porte la note « indicatif »', () {
    for (final slide in SlideKind.values) {
      final note = planOf(kDrawersDefaults.copyWith(slide: slide))!.plan.note;
      expect(
        note,
        slide == SlideKind.undermount ? contains('indicatives') : isNull,
        reason: slide.name,
      );
    }
  });
}
