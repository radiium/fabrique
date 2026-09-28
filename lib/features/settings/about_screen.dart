import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../app/version.dart';
import '../../core/widgets/app_card.dart';
import '../../l10n/app_localizations.dart';
import 'settings_link_card.dart';
import 'settings_screen.dart';

const String _kIconAsset = 'assets/icon/icon.png';

/// Côté de l'icône en tête de page.
const double _kIconSize = 96;

/// Arrondi d'une icône de lanceur, en part de son côté.
const double _kIconCornerRatio = 0.22;

/// Côté de l'icône sur la page des licences.
const double _kLicenseIconSize = 64;

/// L'app, sa version, ses engagements et les licences de ses composants.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.label,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kSettingsMaxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _AppIcon(size: _kIconSize),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    l10n.aboutVersion(kAppVersion),
                    textAlign: TextAlign.center,
                    style: secondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.aboutDescription,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(l10n.aboutPrivacy, style: secondary),
                        const SizedBox(height: AppSpacing.sm),
                        Text(l10n.aboutLicense, style: secondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SettingsLinkCard(
                    label: l10n.aboutLicenses,
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: l10n.appTitle,
                      applicationVersion: kAppVersion,
                      applicationIcon: const Padding(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        child: _AppIcon(size: _kLicenseIconSize),
                      ),
                      applicationLegalese: l10n.aboutLicense,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// L'icône de lanceur, décorative : le nom de l'app la suit.
class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * _kIconCornerRatio),
        child: Image.asset(
          _kIconAsset,
          width: size,
          height: size,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
