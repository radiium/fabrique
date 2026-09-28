import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/persistence/settings_controller.dart';
import '../core/widgets/haptics.dart';
import '../l10n/app_localizations.dart';
import 'locale.dart';
import 'router.dart';
import 'theme.dart';

/// Racine de l'app : réglages globaux, thème, langue et routeur.
class FabriqueApp extends ConsumerWidget {
  const FabriqueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le seul point de lecture du réglage haptique : la portée couvre tout le
    // `Navigator`, feuilles modales comprises.
    return HapticsScope(
      enabled: ref.watch(hapticsEnabledProvider),
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        themeMode: ThemeMode.light,
        routerConfig: ref.watch(routerProvider),
        // `null` suit le téléphone, avec l'anglais en repli.
        locale: ref.watch(appLocaleProvider),
        localeListResolutionCallback: resolveAppLocale,
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
