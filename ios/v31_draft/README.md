# iOS V3.1 — socle natif hors connexion (Brouillon)

**Statut : source préparée, non compilée ni testée. Aucun projet Xcode complet actuellement.**

L'intégration native doit reprendre les vues de `ios/v2_snapshot/App/ContentView.swift` et `ios/v2_snapshot/Widgets/HeritageWidgets.swift` en utilisant les modèles `Shared/ArchiveRepository.swift`. Les composants SwiftUI manquants sont préparés dans `App/HeritageComponents.swift`.

## Intégration future dans Xcode

Créer un projet SwiftUI pour iPhone (cible iOS 17+), puis une extension WidgetKit ; inclure `ArchiveRepository.swift` et les deux fichiers JSON dans **les ressources de chaque cible** lorsque nécessaire. L'application ne doit pas requérir Internet pour charger les textes, dates ou références. Les photographies restent aujourd'hui chargées à partir de leurs URLs et peuvent manquer hors ligne : leur intégration locale est suspendue au budget de taille et à la validation des droits.

Conserver les chemins sources GitHub suivants comme **seule base éditoriale** :
- `data/entries_v2.json` (235 fiches)
- `data/photos_v2.json` (24 notices)

Générer les fichiers de ressources JSON de build depuis ce référentiel sans éditer des copies concurrentes. La mise à jour de contenu n'est **pas automatique** : elle intervient par publication d'une version applicative approuvée.

## Vérifications nécessaires

- Compiler sur macOS avec Xcode : aucun environnement Apple de compilation n'est disponible ici.
- Tester la vraie actualisation WidgetKit, les App Intents, les deep links et les préférences d'apparence.
- Vérifier le contraste, VoiceOver, Dynamic Type, Safe Area, fonctionnement réseau/hors ligne.
- Auditer la photographie et sa licence avant d'en embarquer une copie.

## Rappel

Ce dossier est un **prototype de source**, pas une application installable ni un `.ipa`. L'absence de compilation implique que des corrections d'intégration sont encore possibles.
