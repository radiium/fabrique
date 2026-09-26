import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

const Duration _kDuration = Duration(milliseconds: 180);
const Curve _kCurve = Curves.easeInOut;

/// Panneau repliable : un en-tête cliquable, un contenu qui se déplie.
///
/// Un groupe de la saisie ([ToolScaffold.inputGroups]) : il découpe une
/// saisie qui ne tient pas sur un écran, et fermé, il dit ses valeurs dans
/// son [summary].
///
/// Règle d'emploi : **ce qui est replié garde par défaut une valeur qui ne
/// surprend pas** — neutre (un jeu nul) ou le cas le plus courant (des bords
/// aux éléments) — ou se lit dans le résumé. Sinon on cache à l'utilisateur
/// la raison d'un résultat qui le surprend, et le repli devient un piège au
/// lieu d'un rangement.
///
/// Se pose **de bord à bord** dans la carte, un filet collé au-dessus de
/// l'en-tête : un panneau bordé et encore marginé ferait une carte dans la
/// carte. Il porte donc lui-même la marge horizontale de la carte, pour que
/// son titre reste aligné sur les libellés de ses champs.
///
/// L'état ouvert survit à un changement de mise en page (rotation, fenêtre
/// élargie au-delà de `kWideBreakpoint`) : [ToolScaffold] y reconstruit la
/// carte dans un autre sous-arbre, où le panneau repartirait fermé.
/// Il est rangé dans le [PageStorage] de la route, sous son [title] : deux
/// panneaux d'un même écran ne partagent donc pas un titre.
///
/// Sous un [AppDisclosureGroup], ouvrir un panneau referme les autres.
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

  /// Les valeurs du contenu, lues d'un coup d'œil sous le titre.
  ///
  /// Dans les deux états, grisé une fois le panneau ouvert. Passe à la ligne
  /// plutôt que de tronquer, une valeur coupée ment.
  final String? summary;

  /// Marge du contenu, sur les quatre côtés.
  ///
  /// Le côté est celui de la carte qui le porte ([AppCard.padding]), puisqu'il
  /// en remplace le rembourrage sur toute sa hauteur. Le bas est à la charge
  /// du panneau : la carte n'a plus de rembourrage à lui prêter. Le haut
  /// détache le premier libellé de l'en-tête.
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
        // Une seule animation, la hauteur, et sur le seul contenu : l'en-tête
        // n'en fait pas partie, il suit la frappe du résumé sans délai.
        AnimatedSize(
          duration: _kDuration,
          curve: _kCurve,
          alignment: AlignmentDirectional.topStart,
          // Démonté une fois replié, et non seulement réduit : replié à l'œil
          // seulement, le contenu resterait focusable au clavier et lu par un
          // lecteur d'écran.
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
/// Un panneau qu'on ouvre referme les autres, pour que la saisie reste courte
/// et que le schéma, en dessous, reste à portée. Chaque panneau garde son
/// propre état ouvert dans le [PageStorage] : le groupe ne fait que diffuser
/// le dernier ouvert, il ne restaure rien.
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

  /// L'icône d'un groupe, à la taille standard de Material.
  ///
  /// Le titre qu'elle accompagne fait [kControlFontSize], la taille des
  /// valeurs saisies : plus grand, en `titleLarge` (22), il parlerait plus
  /// fort que les données et égalerait les résultats et le titre de page.
  static const double _iconSize = 24;

  /// Seul, l'en-tête ne porte que la marge de la carte : c'est sa ligne de
  /// titre qui fait la hauteur.
  static const EdgeInsets _inset = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );

  /// Avec un résumé, une même marge au-dessus du titre et sous le résumé :
  /// le bloc se lit centré dans l'en-tête.
  static const EdgeInsets _insetWithSummary = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: 12,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = this.summary;
    // Encre foncée pour l'icône et le titre : c'est elle, et non la taille,
    // qui détache un groupe des libellés gris de ses champs.
    final ink = theme.colorScheme.onSurface;
    final body = theme.textTheme.bodyMedium ?? const TextStyle();

    return Semantics(
      button: true,
      expanded: isExpanded,
      child: DecoratedBox(
        // Le filet de la carte, collé à l'en-tête : c'est lui qui dit que ce
        // qui suit est un pied, et non le contrôle suivant. Peint devant :
        // derrière, l'encre du tap le recouvre.
        position: DecorationPosition.foreground,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        // Pas de fond : sur la carte blanche, une teinte légère ne se
        // distinguerait pas du fond de page, et une plus marquée ferait une
        // carte dans la carte. Le contenu déplié dit assez « ouvert ». Le
        // `Material` transparent ne sert qu'à porter l'encre de l'`InkWell`.
        child: Material(
          type: MaterialType.transparency,
          // Pas de `borderRadius` sur l'encre : l'en-tête va de bord à bord,
          // c'est la carte qui détoure ses coins.
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: summary == null ? _inset : _insetWithSummary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ligne à part du résumé : le titre reste en face de l'icône
                  // et du chevron. Seule, elle fait la cible tactile
                  // d'atelier. Suivie d'un résumé, c'est l'en-tête entier qui
                  // la fait, au-delà de 48.
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: summary == null ? kFieldHeight : 0,
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
                  // Aligné sur l'icône, pas sur le titre : toute la largeur de
                  // la carte pour des valeurs qui s'allongent vite. Affiché
                  // dans les deux états : ouvert, le résumé suit la frappe.
                  // Grisé alors, pour reculer derrière les champs qui disent
                  // la même chose.
                  if (summary != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: AnimatedDefaultTextStyle(
                        duration: _kDuration,
                        curve: _kCurve,
                        style: body.copyWith(
                          color: isExpanded ? AppColors.label : body.color,
                        ),
                        child: Text(summary),
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
