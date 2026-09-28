import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

const Duration _kDuration = Duration(milliseconds: 180);
const Curve _kCurve = Curves.easeInOut;

/// Panneau repliable : un en-tête cliquable, un contenu qui se déplie.
///
/// Replié, il garde une valeur neutre ou courante, ou l'affiche dans son
/// [summary]. Il se pose de bord à bord dans la carte et porte sa marge.
/// L'état ouvert est rangé dans le [PageStorage] sous [title], unique par
/// écran. Sous un [AppDisclosureGroup], ouvrir un panneau referme les autres.
class AppDisclosure extends StatefulWidget {
  const AppDisclosure({
    required this.title,
    required this.child,
    this.icon = Icons.tune,
    this.initiallyExpanded = false,
    this.summary,
    super.key,
  });

  final String title;
  final Widget child;
  final IconData icon;
  final bool initiallyExpanded;

  /// Les valeurs du contenu, sous le titre, panneau fermé seulement.
  ///
  /// Passe à la ligne plutôt que de tronquer.
  final String? summary;

  /// Marge du contenu : côtés de la carte ([AppCard.padding]), et le bas que la
  /// carte ne fournit plus.
  static const EdgeInsets _bodyInset = EdgeInsets.all(AppSpacing.md);

  @override
  State<AppDisclosure> createState() => _AppDisclosureState();
}

class _AppDisclosureState extends State<AppDisclosure> {
  late bool _expanded;
  ValueNotifier<String?>? _group;

  Object get _storageId => (AppDisclosure, widget.title);

  @override
  void initState() {
    super.initState();
    _expanded =
        PageStorage.maybeOf(context)?.readState(context, identifier: _storageId)
            as bool? ??
        widget.initiallyExpanded;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final group = context
        .dependOnInheritedWidgetOfExactType<_DisclosureGroupScope>()
        ?.lastOpened;
    if (group == _group) return;
    _group?.removeListener(_onGroupChanged);
    _group = group?..addListener(_onGroupChanged);
  }

  @override
  void dispose() {
    _group?.removeListener(_onGroupChanged);
    super.dispose();
  }

  void _onGroupChanged() {
    if (_expanded && _group?.value != widget.title) _setExpanded(false);
  }

  void _toggle() {
    hapticSelection(context);
    _setExpanded(!_expanded);
    if (_expanded) _group?.value = widget.title;
  }

  void _setExpanded(bool isExpanded) {
    setState(() => _expanded = isExpanded);
    PageStorage.maybeOf(context)
        ?.writeState(context, _expanded, identifier: _storageId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DisclosureHeader(
          title: widget.title,
          icon: widget.icon,
          summary: widget.summary,
          isExpanded: _expanded,
          onTap: _toggle,
        ),
        // Une seule animation de hauteur, pour le contenu et le résumé.
        AnimatedSize(
          duration: _kDuration,
          curve: _kCurve,
          alignment: AlignmentDirectional.topStart,
          // Démonté une fois replié : sinon il reste focusable et lu par un lecteur
          // d'écran.
          child: _expanded
              ? Padding(padding: AppDisclosure._bodyInset, child: widget.child)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Accordéon : sous lui, un seul [AppDisclosure] ouvert à la fois.
///
/// Le groupe diffuse le dernier ouvert ; chaque panneau garde son état.
class AppDisclosureGroup extends StatefulWidget {
  const AppDisclosureGroup({required this.child, super.key});

  final Widget child;

  @override
  State<AppDisclosureGroup> createState() => _AppDisclosureGroupState();
}

class _AppDisclosureGroupState extends State<AppDisclosureGroup> {
  final ValueNotifier<String?> _lastOpened = ValueNotifier(null);

  @override
  void dispose() {
    _lastOpened.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _DisclosureGroupScope(lastOpened: _lastOpened, child: widget.child);
}

class _DisclosureGroupScope extends InheritedWidget {
  const _DisclosureGroupScope({required this.lastOpened, required super.child});

  /// Titre du dernier panneau ouvert.
  final ValueNotifier<String?> lastOpened;

  @override
  bool updateShouldNotify(_DisclosureGroupScope oldWidget) =>
      lastOpened != oldWidget.lastOpened;
}

/// En-tête du panneau : icône, titre, chevron, et le résumé en dessous.
class _DisclosureHeader extends StatelessWidget {
  const _DisclosureHeader({
    required this.title,
    required this.icon,
    required this.summary,
    required this.isExpanded,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String? summary;
  final bool isExpanded;
  final VoidCallback onTap;

  /// Icône à la taille standard de Material. Le titre reste à
  /// [kControlFontSize] pour ne pas dominer les données.
  static const double _iconSize = 24;

  /// Sans résumé, la ligne de titre fait la hauteur.
  static const EdgeInsets _inset = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );

  /// Avec résumé, même marge au-dessus du titre et sous le résumé.
  static const EdgeInsets _insetWithSummary = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: 12,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = this.summary;
    // Encre foncée : c'est elle qui détache le titre des libellés gris.
    final ink = theme.colorScheme.onSurface;

    return Semantics(
      button: true,
      expanded: isExpanded,
      child: DecoratedBox(
        // Filet de la carte, peint devant : derrière, l'encre du tap le recouvre.
        position: DecorationPosition.foreground,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        // Sans fond : une teinte ne se distinguerait pas du fond de page. Le
        // `Material` transparent porte l'encre de l'`InkWell`.
        child: Material(
          type: MaterialType.transparency,
          // Sans `borderRadius` : la carte détoure les coins.
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: summary == null ? _inset : _insetWithSummary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Seule, la ligne de titre fait la cible tactile ; avec un résumé,
                  // l'en-tête entier la fait, marges comprises.
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: summary == null
                          ? kFieldHeight
                          : kFieldHeight - _insetWithSummary.vertical,
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: _iconSize, color: ink),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: kControlFontSize,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: _kDuration,
                          curve: _kCurve,
                          child: const Icon(
                            Icons.expand_more,
                            color: AppColors.label,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Aligné sur l'icône, pour toute la largeur. Replié au rythme du
                  // contenu, marges fixes, pour que l'en-tête ne saute pas.
                  if (summary != null)
                    AnimatedSize(
                      duration: _kDuration,
                      curve: _kCurve,
                      alignment: AlignmentDirectional.topStart,
                      child: isExpanded
                          ? const SizedBox(width: double.infinity)
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.xs,
                              ),
                              child: Text(
                                summary,
                                style: theme.textTheme.bodyMedium,
                              ),
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
