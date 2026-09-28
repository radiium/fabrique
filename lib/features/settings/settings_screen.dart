import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../app/version.dart';
import '../../core/persistence/settings_controller.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_switch_field.dart';
import '../../core/widgets/haptics.dart';
import '../../core/widgets/labeled_field.dart';
import '../../l10n/app_localizations.dart';
import 'settings_link_card.dart';

/// Largeur maximale des pages de réglages, centrées horizontalement au-delà.
const double kSettingsMaxWidth = 560;

/// Haptique et langue, le thème verrouillé pour cette version, le lien vers
/// « À propos » et la version en pied de page.
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
          AsyncError(:final error) => _LoadFailure(message: '$error'),
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
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverList.list(
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        // Liste déroulante : « Langue du téléphone » ne tient
                        // pas en segment.
                        LabeledField(
                          label: l10n.language,
                          child: AppDropdown<AppLanguage>(
                            value: settings.language,
                            onSelected: controller.setLanguage,
                            entries: {
                              for (final language in AppLanguage.values)
                                language: switch (language) {
                                  AppLanguage.system => l10n.languageSystem,
                                  AppLanguage.fr => l10n.languageFrench,
                                  AppLanguage.en => l10n.languageEnglish,
                                },
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Ce qui ne se règle pas vit à part, sans apparence cliquable.
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.settingsLockedSection,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: AppColors.label),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _LockedRow(
                          label: l10n.theme,
                          value: l10n.themeLightLocked,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SettingsLinkCard(
                    label: l10n.about,
                    onTap: () => context.go(AppRoutes.about),
                  ),
                ],
              ),
            ),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _VersionFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

/// La version, en bas de l'écran, ou sous la dernière carte si la page défile.
class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Text(
          AppLocalizations.of(context).aboutVersion(kAppVersion),
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.label),
        ),
      ),
    );
  }
}

/// Un réglage verrouillé : affiché, avec son cadenas, jamais actionnable.
class _LockedRow extends StatelessWidget {
  const _LockedRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      enabled: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, size: 18, color: AppColors.label),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.label,
                ),
              ),
            ),
            Text(value, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

/// `shared_preferences` indisponible : rien ne serait enregistré.
class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.cut),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppLocalizations.of(context).settingsLoadFailed,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.label,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
