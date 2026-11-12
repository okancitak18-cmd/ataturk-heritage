# Parcours natif V3.1 — écran historique et widgets

Les fichiers de ce dossier ont été préparés ensemble :
- `App/AtaturkHeritageApp.swift` et `App/ContentView.swift` : réception du schéma `ataturkheritage://entry/<id>`, ouverture de la fiche exacte et synchronisation de la sélection au moment de l'ouverture.
- `Widgets/HeritageWidgets.swift` : widget moyen/grand avec boutons précédent/suivant App Intents, provider lisant l'état partagé, et `widgetURL` direct vers la fiche affichée.
- `Shared/HeritageWidgetNavigation.swift` : état partagé (App Group) et routage.
- `Widgets/HeritageWidgetIntents.swift` : navigation native bidirectionnelle.

**Les boutons et liens ne sont pas encore installables.** Ces fichiers doivent être regroupés dans de vraies cibles Xcode, pour lesquelles aucune compilation n'a été exécutée. Le scheme URL et l'App Group proposés ne sont pas configurés dans des entitlements Apple.

**Points d'acceptation** : iPhone réel, widget moyen/grand, écran verrouillé, coupure réseau, date locale qui change, validité de la sélection, préférences indépendantes et fallback si le widget ne peut pas interagir. Les contrôles plus compacts doivent être conçus séparément.

Ne pas fusionner ni publier avant accord du propriétaire, sauvegarde de l'ancienne version et recette appropriée.
