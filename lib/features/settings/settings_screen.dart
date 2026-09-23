import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/persistence/settings_controller.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_switch_field.dart';
import '../../l10n/app_localizations.dart';

/// Au-delà, le formulaire cesse de s'étirer et se centre *horizontalement* :
/// une ligne de switch large de 1400 px n'a pas de sens, et les écrans-outils
/// passent eux aussi en colonnes plutôt qu'en pleine largeur. Verticalement il
/// reste collé en haut, comme toutes les autres pages.
const double _maxFormWidth = 560;

/// Liste courte : haptique, plus le thème et la langue, arrêtés pour cette
/// version.
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
          _ => _SettingsForm(settings: settings.value!),
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
        constraints: const BoxConstraints(maxWidth: _maxFormWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSwitchField(
                      label: l10n.haptics,
                      help: l10n.hapticsHelp,
                      value: settings.haptics,
                      onChanged: controller.setHaptics,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Ce qui ne se règle pas vit à part, et le dit. Une ListTile
              // d'apparence cliquable qui ne répond pas est pire que rien.
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
                    _LockedRow(label: l10n.theme, value: l10n.themeLightLocked),
                    _LockedRow(
                      label: l10n.language,
                      value: l10n.languageFrench,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Un réglage arrêté pour cette version : affiché, expliqué par son cadenas,
/// jamais présenté comme actionnable.
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

/// `shared_preferences` indisponible : on le dit franchement plutôt que
/// d'afficher un formulaire dont rien ne serait enregistré.
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
