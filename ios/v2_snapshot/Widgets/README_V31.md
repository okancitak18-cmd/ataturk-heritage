# V3.1 — Présentation native des textes de widgets (snapshot de conception)

Le fichier `ios/v2_snapshot/Widgets/HeritageWidgets.swift` a été adapté pour distinguer les extraits des citations complètes et moduler les limites selon les familles : inline, rectangulaire, petit carré, moyen et grand.

**Ce code est un snapshot SwiftUI, pas un projet Xcode complet. Il n'a pas été compilé sur macOS ni vérifié avec WidgetKit.**

- Toujours présenter explicitement « EXTRAIT » lorsqu'une citation est raccourcie.
- Conserver l'intégralité dans le corpus et fournir plus tard un lien profond vers la fiche correspondante (objectif 31-7).
- Réévaluer les limites de caractères selon les langues, Dynamic Type et le rendu réellement mesuré.
- La vue native ne doit pas supposer qu'un aperçu textuel produit par une limite de caractères sera entièrement visible dans toutes les tailles; prévoir des tests sur iPhone.
- Pas de synchronisation automatique distante ; mise à jour par version iOS selon 31-10.

Aucune fonction App Intents ni navigation par deep link n'est présentée comme terminée dans ce lot.
