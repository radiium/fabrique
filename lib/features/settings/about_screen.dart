import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../app/version.dart';
import '../../core/widgets/app_card.dart';
import '../../l10n/app_localizations.dart';
import 'settings_link_card.dart';
import 'settings_screen.dart';

const String _kIconAsset = 'assets/icon/icon.png';

/// Le dépôt public : sources, tags de version et suivi des bugs.
final Uri _kRepositoryUrl = Uri.https('github.com', '/radiium/fabrique');

/// Côté de l'icône en tête de page.
const double _kIconSize = 96;

/// Arrondi d'une icône de lanceur, en part de son côté.
const double _kIconCornerRatio = 0.22;

/// Côté de l'icône sur la page des licences.
const double _kLicenseIconSize = 64;

/// L'app, sa version, ses engagements, son dépôt et les licences de ses
/// composants.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyMedium;
    final secondary = body?.copyWith(color: AppColors.label);

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
                        Text(l10n.aboutDescription, style: body),
                        const Divider(height: AppSpacing.lg),
                        Text(l10n.aboutPrivacy, style: body),
                        const Divider(height: AppSpacing.lg),
                        Text(l10n.aboutLicense, style: body),
                        Text(l10n.aboutCopyright, style: body),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SettingsLinkCard(
                    label: l10n.aboutSource,
                    subtitle: '${_kRepositoryUrl.host}${_kRepositoryUrl.path}',
                    isExternal: true,
                    onTap: () => _openRepository(context),
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
                      applicationLegalese:
                          '${l10n.aboutCopyright}\n${l10n.aboutLicense}',
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

/// Ouvre le dépôt dans le navigateur, ou dit pourquoi le lien ne s'ouvre pas.
Future<void> _openRepository(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  final message = AppLocalizations.of(context)
      .aboutLinkFailed('$_kRepositoryUrl');
  bool isOpened;
  try {
    isOpened = await launchUrl(
      _kRepositoryUrl,
      mode: LaunchMode.externalApplication,
    );
  } on Object catch (error) {
    debugPrint('À propos : lien du dépôt ($error)');
    isOpened = false;
  }
  if (!isOpened) messenger.showSnackBar(SnackBar(content: Text(message)));
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
