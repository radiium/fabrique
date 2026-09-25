import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/format.dart';
import 'package:fabrique/core/models/enums.dart';
import 'package:fabrique/core/widgets/app_dropdown.dart';
import 'package:fabrique/core/widgets/error_banner.dart';
import 'package:fabrique/core/widgets/schema_card.dart';
import 'package:fabrique/features/layout/layout_controller.dart';
import 'package:fabrique/features/layout/layout_presets.dart';
import 'package:fabrique/features/layout/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/phone.dart';

/// Le Calepinage a huit contrôles, en trois groupes repliables. Un painter qui lève sur
/// un jeu périphérique, un contrôle sorti de son groupe : ni `flutter analyze` ni
/// les tests du cœur ne peuvent l'attraper.
void main() {
  Future<ProviderContainer> pumpLayout(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildAppTheme(), home: const LayoutScreen()),
      ),
    );
    return container;
  }

  Future<void> open(WidgetTester tester, String group) async {
    await tester.tap(find.text(group));
    await tester.pumpAndSettle();
  }

  testWidgets('seule la surface est dépliée à l’arrivée', (tester) async {
    usePhone(tester);
    await pumpLayout(tester);

    expect(find.text('Surface — largeur'), findsOneWidget);
    for (final label in const [
      'Matériau',
      'Élément — largeur',
      'Inverser l’orientation',
      'Jeu horizontal',
      'Jeu périphérique',
    ]) {
      expect(find.text(label), findsNothing, reason: label);
    }
  });

  testWidgets('chaque groupe résume ses valeurs, sans rien tronquer', (
    tester,
  ) async {
    usePhone(tester);
    await pumpLayout(tester);

    for (final summary in const [
      '3000 × 2000 mm',
      '1200 × 200 mm · décalage ½',
      'Aucun jeu',
    ]) {
      final finder = find.text(summary);
      expect(finder, findsOneWidget, reason: summary);
      expect(
        tester.renderObject<RenderParagraph>(finder).didExceedMaxLines,
        isFalse,
        reason: summary,
      );
    }
  });

  testWidgets('le résumé nomme le matériau, et les options allumées', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpLayout(tester);
    container.read(layoutFormProvider.notifier)
      // Inversé d'abord : le preset traduit ses jeux selon le sens de pose.
      ..setFlip(true)
      ..applyPreset(kLayoutPresets.firstWhere((p) => p.label.startsWith('Ter')))
      ..setBalanceRows(true);
    await tester.pump();

    // Le preset remplit aussi les jeux, repliés : c'est leur résumé qui le
    // dit sans déplier.
    final input = container.read(layoutFormProvider);
    expect(
      find.text(
        'Terrasse 4000×145 · décalage droit · orientation inversée · '
        'rangées équilibrées',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'entre éléments ${formatNumber(input.gapX)} × '
        '${formatNumber(input.gapY)} · périphérique 10 mm',
      ),
      findsOneWidget,
    );
  });

  testWidgets('les groupes vont de bord à bord de la carte', (tester) async {
    // Une marge de carte revenue ferait des groupes une carte dans la carte,
    // et ça ne se voit qu'au rendu.
    usePhone(tester);
    await pumpLayout(tester);

    final card = tester.getRect(
      find.ancestor(
        of: find.text('Surface — largeur'),
        matching: find.byType(Card),
      ),
    );
    // `.first` : « Surface » est aussi une tuile de résultat, plus bas.
    Rect header(String title) => tester.getRect(
      find
          .ancestor(of: find.text(title).first, matching: find.byType(InkWell))
          .first,
    );

    expect(header('Surface').top, card.top);
    expect(header('Surface').left, card.left);
    expect(header('Jeux').right, card.right);
    expect(header('Jeux').bottom, card.bottom);
  });

  testWidgets('les options du v2 se rendent sans lever', (tester) async {
    usePhone(tester);
    final container = await pumpLayout(tester);
    final form = container.read(layoutFormProvider.notifier);

    for (final offset in JointOffset.values) {
      for (final flip in [false, true]) {
        form
          ..setOffset(offset)
          ..setFlip(flip)
          ..setPerimeterGap(15)
          ..setBalanceRows(true);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$offset / flip $flip');
      }
    }
  });

  testWidgets('la tuile des rangées de bord n’apparaît qu’équilibrée', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpLayout(tester);
    final form = container.read(layoutFormProvider.notifier);

    expect(find.text('Rangées de bord'), findsNothing);

    // 2010 de long pour des éléments de 200 : la dernière rangée ferait 10 mm.
    form
      ..setSurfaceY(2010)
      ..setElementX(2000)
      ..setElementY(200)
      ..setSurfaceX(2000)
      ..setOffset(JointOffset.straight)
      ..setBalanceRows(true);
    await tester.pumpAndSettle();

    expect(find.text('Rangées de bord'), findsOneWidget);
    expect(find.text('105'), findsOneWidget);
  });

  testWidgets('une saisie refusée montre son motif, pas un tiret muet', (
    tester,
  ) async {
    // Huit contrôles : un tiret laisserait chercher lequel est fautif.
    usePhone(tester);
    final container = await pumpLayout(tester);
    final form = container.read(layoutFormProvider.notifier);

    expect(find.byType(ErrorBanner), findsNothing);

    form
      ..setElementX(1)
      ..setElementY(1);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ErrorBanner), findsOneWidget);
    expect(find.text('Rangées de bord'), findsNothing);

    form
      ..setElementX(1200)
      ..setElementY(200);
    await tester.pumpAndSettle();
    expect(find.byType(ErrorBanner), findsNothing);
  });

  testWidgets('le refus se lit dans la carte de saisie, pas sous le schéma', (
    tester,
  ) async {
    // Sur mobile les résultats sont sous le schéma : un message posé là se
    // lirait deux écrans plus bas que le champ à corriger.
    usePhone(tester);
    final container = await pumpLayout(tester);
    container.read(layoutFormProvider.notifier).setElementX(9000);
    await tester.pumpAndSettle();

    final banner = tester.getRect(find.byType(ErrorBanner));
    final schema = tester.getRect(find.byType(SchemaCard));
    expect(banner.bottom, lessThan(schema.top));
  });

  group('presets', () {
    testWidgets('remplissent format, jeux et décalage d’un coup', (
      tester,
    ) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      await open(tester, 'Élément et pose');

      await tester.tap(find.byType(AppDropdown<LayoutPreset?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terrasse 4000×145').last);
      await tester.pumpAndSettle();

      final input = container.read(layoutFormProvider);
      expect(input.elementX, 4000);
      expect(input.elementY, 145);
      // 3 mm en bout le long de la lame, 5 mm entre lames : le seul preset de
      // la table dont les deux jeux diffèrent.
      expect(input.gapX, 3);
      expect(input.gapY, 5);
      expect(input.perimeterGap, 10);
      expect(input.offset, JointOffset.straight);
      // La surface vient de la pièce, pas du matériau.
      expect(input.surfaceX, kLayoutDefaults.surfaceX);
      expect(input.surfaceY, kLayoutDefaults.surfaceY);
    });

    testWidgets('les jeux suivent le sens de pose', (tester) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      container.read(layoutFormProvider.notifier).setFlip(true);
      await open(tester, 'Élément et pose');

      await tester.tap(find.byType(AppDropdown<LayoutPreset?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terrasse 4000×145').last);
      await tester.pumpAndSettle();

      // Inversé, l'axe de pose est Y : le jeu en bout y passe, et celui entre
      // lames revient à X. La convention « les jeux restent définis à l'écran »
      // ne bouge pas, c'est le remplissage qui traduit.
      final input = container.read(layoutFormProvider);
      expect(input.gapX, 5);
      expect(input.gapY, 3);
    });

    testWidgets('la valeur se dérive de la saisie', (tester) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      final form = container.read(layoutFormProvider.notifier);
      await open(tester, 'Élément et pose');

      expect(find.text('Personnalisé'), findsOneWidget);

      form.applyPreset(kLayoutPresets.first);
      await tester.pumpAndSettle();
      expect(find.text('Placo 1200×2500'), findsOneWidget);
      expect(find.text('Personnalisé'), findsNothing);

      // Une cote touchée à la main, et le sélecteur le dit — sans que rien
      // n'ait été stocké à côté de la saisie.
      form.setElementX(1201);
      await tester.pumpAndSettle();
      expect(find.text('Placo 1200×2500'), findsNothing);
      expect(find.text('Personnalisé'), findsOneWidget);
    });

    testWidgets('« Personnalisé » ne s’offre pas quand un preset est pris', (
      tester,
    ) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      container
          .read(layoutFormProvider.notifier)
          .applyPreset(kLayoutPresets.first);
      await open(tester, 'Élément et pose');

      await tester.tap(find.byType(AppDropdown<LayoutPreset?>));
      await tester.pumpAndSettle();

      // Une entrée qui ne fait rien quand on la choisit n'a rien à faire dans
      // la liste.
      expect(find.text('Personnalisé'), findsNothing);
      expect(find.text('Carrelage 600×600'), findsWidgets);
    });

    testWidgets('chaque preset se rend sans lever', (tester) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      final form = container.read(layoutFormProvider.notifier);

      for (final preset in kLayoutPresets) {
        form.applyPreset(preset);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: preset.label);
      }
    });

    testWidgets('aucun libellé ne déborde la valeur fermée', (tester) async {
      usePhone(tester);
      await pumpLayout(tester);
      await open(tester, 'Élément et pose');

      final field = find.byType(AppDropdown<LayoutPreset?>);
      final closed = tester.getRect(find.text('Personnalisé'));
      final available = closed.width;
      final style = controlTextStyle(tester.element(field));

      // ⚠️ Mesure divisée par deux, et c'est assumé. La police des tests donne
      // à chaque glyphe la largeur de la taille de police, soit environ le
      // double d'une vraie police — et un nom de produit suivi de deux cotes
      // ne tient jamais dans les 14 caractères que cette mesure autorise ici.
      // Le seuil brut est donc inatteignable par construction pour ce
      // contrôle, là où il reste tenable pour un segment.
      //
      // Ce qui est gardé, c'est le rapport : un libellé qui grossirait d'un
      // tiers tomberait quand même.
      const testFontFactor = 2;
      for (final preset in kLayoutPresets) {
        final painter = TextPainter(
          text: TextSpan(text: preset.label, style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        expect(
          painter.width / testFontFactor,
          lessThan(available),
          reason: '« ${preset.label} » déborde la valeur fermée',
        );
      }
    });
  });
}
