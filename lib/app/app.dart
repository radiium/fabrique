import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/persistence/settings_controller.dart';
import '../core/widgets/haptics.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

/// i18n câblé, publié en FR seulement.
class FabriqueApp extends ConsumerWidget {
  const FabriqueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le seul point où le réglage haptique est lu : la portée le descend
    // jusqu'aux contrôles, overlays et feuilles modales compris, qui vivent
    // tous sous le `Navigator` de l'app.
    return HapticsScope(
      enabled: ref.watch(hapticsEnabledProvider),
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        themeMode: ThemeMode.light,
        routerConfig: ref.watch(routerProvider),
        locale: const Locale('fr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
