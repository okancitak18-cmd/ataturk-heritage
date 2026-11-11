# Widgets interactifs V3.1 — conception native en cours

Le code de ce dossier prépare les décisions 31-6 et 31-7 : navigation **Précédent / Suivant** selon l'ordre chronologique, ouverture de la **fiche réellement affichée**, contenu identique à l'application.

## Fichiers
- `Shared/HeritageWidgetNavigation.swift` : ID de fiche partagé, date de sélection, lien profond.
- `Widgets/HeritageWidgetIntents.swift` : deux App Intents.

## Intégration indispensable avant exécution
1. Créer les cibles App SwiftUI et WidgetKit dans Xcode (iOS 17 minimum).
2. Ajouter l'App Groups capability **aux deux cibles** avec un identifiant identique (proposition de code : `group.ataturkheritage.shared` ; **non configuré à ce jour**).
3. Inclure `ArchiveRepository.swift`, les ressources JSON et `HeritageWidgetNavigation.swift` dans les deux cibles.
4. Inclure les deux intents dans la cible WidgetKit et la cible application selon les règles Apple.
5. Dans le provider WidgetKit, remplacer le choix fixe par `HeritageSharedState.currentEntry(on: date)`, y compris après les intents.
6. Sur le widget moyen et grand, ajouter des `Button(intent: HeritageNextEntryIntent())` et `Button(intent: HeritagePreviousEntryIntent())`, si leurs tailles et zones tactiles sont acceptables. Les formats verrouillés ont un comportement limité.
7. Poser `.widgetURL(HeritageDeepLink.url(for: entry.id))` sur la vue du widget (une seule déclaration dans la hiérarchie) et ouvrir la fiche correspondante depuis `.onOpenURL` dans SwiftUI.
8. Ajouter le scheme d'URL personnalisé `ataturkheritage` dans la configuration de l'application, puis vérifier l'absence de collision avec d'autres schémas.
9. Tester le changement de journée et la sélection partagée sur appareil réel, y compris mode verrouillé et hors connexion.

**État : code préparé, non compilé.** Il ne constitue pas un widget fonctionnel livré. Aucune garantie de propagation immédiate par WidgetKit.

Apple : https://developer.apple.com/documentation/widgetkit/adding-interactivity-to-widgets-and-live-activities et https://developer.apple.com/documentation/widgetkit/linking-to-specific-app-scenes-from-your-widget-or-live-activity
