import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/locale.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../app/version.dart';
import '../../core/persistence/settings_controller.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_switch_field.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/haptics.dart';
import '../../core/widgets/labeled_field.dart';
import '../../l10n/app_localizations.dart';
import 'settings_link_card.dart';

/// Largeur maximale des pages de réglages, centrées horizontalement au-delà.
const double kSettingsMaxWidth = 560;

/// Haptique et langue, puis le lien vers « À propos » avec la version.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: switch (settings) {
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
          // Le contrôleur retombe sur les défauts plutôt que d'échouer.
          AsyncError() => const _SettingsForm(settings: Settings()),
          AsyncData(:final value) => _SettingsForm(settings: value),
        },
      ),
    );
  }
}

class _SettingsForm extends ConsumerWidget {
  const _SettingsForm({required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kSettingsMaxWidth),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (ref.watch(settingsStorageFailedProvider)) ...[
              ErrorBanner(message: l10n.settingsNotSaved),
              const SizedBox(height: AppSpacing.md),
            ],
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Le web ne vibre pas : le réglage n'y gouvernerait rien.
                  if (!kIsWeb) ...[
                    // Vibre selon la valeur choisie, pas l'ancienne :
                    // l'activer se sent, le couper reste muet.
                    HapticsScope(
                      enabled: !settings.haptics,
                      child: AppSwitchField(
                        label: l10n.haptics,
                        help: l10n.hapticsHelp,
                        value: settings.haptics,
                        onChanged: controller.setHaptics,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  // Liste déroulante : « Langue de l'appareil (Français) »
                  // ne tient pas en segment.
                  LabeledField(
                    label: l10n.language,
                    child: AppDropdown<AppLanguage>(
                      value: settings.language,
                      onSelected: controller.setLanguage,
                      entries: {
                        for (final language in AppLanguage.values)
                          language: _languageLabel(l10n, language),
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsLinkCard(
              label: l10n.about,
              value: kAppVersion,
              onTap: () => context.go(AppRoutes.about),
            ),
          ],
        ),
      ),
    );
  }
}

/// Le libellé d'une langue : son nom écrit dans cette langue, ou pour
/// [AppLanguage.system] la langue que l'app retient de l'appareil.
String _languageLabel(AppLocalizations l10n, AppLanguage language) =>
    switch (language) {
      AppLanguage.system => l10n.languageSystem(
        _languageLabel(l10n, _deviceLanguage()),
      ),
      AppLanguage.fr => l10n.languageFrench,
      AppLanguage.en => l10n.languageEnglish,
    };

/// La langue que l'app retient de l'appareil, par la même règle que la racine.
///
/// Jamais [AppLanguage.system] : [_languageLabel] s'appellerait sans fin.
AppLanguage _deviceLanguage() {
  final resolved = resolveAppLocale(
    WidgetsBinding.instance.platformDispatcher.locales,
    AppLocalizations.supportedLocales,
  );
  return AppLanguage.values.firstWhere(
    (language) => language.locale?.languageCode == resolved.languageCode,
    orElse: () => AppLanguage.fr,
  );
}
