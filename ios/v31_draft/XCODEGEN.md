# Première génération d'un projet Xcode — V3.1 (non compilé)

Cette configuration `project.yml` permet de générer une **structure Xcode** comprenant l'application SwiftUI, l'extension WidgetKit, les données locales et le code App Intents. Elle utilise l'outil tiers open source [XcodeGen](https://github.com/yonaskolb/XcodeGen) et reste **à tester sur macOS/Xcode**.

Depuis la racine du dépôt :

```bash
node scripts/package-ios-v31.mjs --out ios/v31_draft/Resources
cd ios/v31_draft
xcodegen generate
open ATATURKHeritage.xcodeproj
```

Avant de compiler et de signer :

1. Remplacer les deux Bundle Identifiers d'exemple `com.example.*` par des identifiants correspondant au compte développeur Apple du propriétaire.
2. Configurer la signature Apple Developer pour les deux cibles.
3. Créer/activer la **même App Group** dans les deux cibles et dans le portail Apple Developer ; modifier `HeritageSharedState.appGroupID` ainsi que les entitlements générés si l'identifiant est différent.
4. Confirmer dans Xcode que les ressources `entries_v2.json` et `photos_v2.json` sont intégrées à la copie de ressources des **deux** cibles.
5. Vérifier le schéma d'URL `ataturkheritage://entry/<id>` dans l'app et les liens `.widgetURL`.
6. Ajouter un asset catalog/AppIcon final, régler les avertissements de build, puis tester sur simulateur et iPhone réel.
7. Contrôler les textes longs, les interactions App Intents, les familles WidgetKit, VoiceOver et le mode hors connexion.

**Important :** XcodeGen et Xcode n'ont pas été exécutés ici. Le projet Xcode **n'est pas encore généré**, aucune compilation, signature ou installation n'est confirmée. Le fichier `project.yml` est un point de départ modifiable, pas une garantie de build sans corrections.

Le contenu textuel est embarqué ; les images distantes ne le sont pas, en attente des vérifications des licences et du budget de taille.
