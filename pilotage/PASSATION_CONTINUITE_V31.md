# ATATÜRK Heritage — passation de travail entre conversations

**Mise à jour initiale : 11 novembre 2026**  
**Dépôt :** `okancitak18-cmd/ataturk-heritage`  
**Développement :** `feature/v31-separation-app-laboratoire`, PR #17 en brouillon  
**Site public :** préversion intermédiaire V3.1 sur `main` après autorisation explicite, publication finale toujours soumise à validation.

## Publication intermédiaire — décision et résultat (11 novembre 2026)

- **Décision propriétaire : publication intermédiaire autorisée**, avec réédition possible après validation finale V3.1.
- **PR #18 fusionnée** : https://github.com/okancitak18-cmd/ataturk-heritage/pull/18
- **GitHub Pages déployé avec succès** : https://github.com/okancitak18-cmd/ataturk-heritage/actions/runs/43129420609
- **Nouveau main** : `246ee65481b17064e912d9a43267dd1ce6816108` ; précédemment `d4375729165e8ed9e70b45fb74ab65e86f214626`.
- **Deux sauvegardes web** dans `main` : `versions/v3.1.1/` et `versions/v3.1-intermediaire/` ; application et laboratoire à chaque fois.
- Seules les interfaces HTML, le manifeste PWA et la documentation de publication sont diffusés ; **la PR #17 demeure en brouillon** pour le développement natif et les audits.
- L'application web est installable sur l'écran d'accueil Safari comme **web app**, pas une app SwiftUI dotée de WidgetKit.
- **Compilation Xcode CI réussie** : run https://github.com/okancitak18-cmd/ataturk-heritage/actions/runs/43127593039, app et extension WidgetKit pour simulateur **non signé** (Xcode 16.4).
- **Pas d'IPA natif installable** pour le moment. Les choix possibles sans Mac : TestFlight via build cloud (lien d'invitation, sans publication publique App Store) ou IPA Ad Hoc signé et lien OTA lié à l'UDID. Voir `ios/v31_draft/DISTRIBUTION_SANS_MAC.md`.
- **Bloqueur utilisateur** : confirmer l'existence d'un abonnement Apple Developer Program actif ; ne jamais envoyer les secrets Apple dans la conversation.

## Nouveau circuit gratuit d'installation personnelle (11 novembre 2026)

- Le propriétaire n'a **pas d'abonnement Apple Developer Program** et souhaite installer une application SwiftUI **sans Mac ni App Store public**.
- Option gratuite mise en place : édition iPhone personnelle **sans widgets** (`ios/v31_draft/project-personal.yml`), état local dans `UserDefaults.standard` au lieu d'un App Group.
- Nouveau workflow `.github/workflows/ios-personal-ipa.yml` : compilation Release `generic/platform=iOS`, IPA **non signée** et SHA-256 publiés comme artifact GitHub Actions (rétention 14 jours). **Premier run vert** : https://github.com/okancitak18-cmd/ataturk-heritage/actions/runs/43131394800 .
- Documentation utilisateur : `ios/v31_draft/INSTALLATION_PERSONNELLE_GRATUITE.md` et `DISTRIBUTION_SANS_MAC.md`.
- Étape nécessaire : installation/signature de l'IPA avec **AltStore Classic sur un PC Windows**, ou **SideStore avec accès initial à un ordinateur**. Gratuit, personnel, à renouveler tous les 7 jours. L'IPA seule n'est pas installable par Safari.
- La fonctionnalité **WidgetKit native** reste dans le projet complet non publié ; elle n'est pas comprise dans cette édition de sideload personnel.
- Le premier IPA a été généré et empaqueté sur CI, mais **l'installation sur l'iPhone du propriétaire et la recette tactile restent non testées**.
- Le site Pages préversion V3.1 déjà publié n'est pas modifié par ces changements ; poursuivre la PR #17, ne pas fusionner de futurs changements sans autorisation spécifique.

## Démarrage d'une nouvelle conversation

1. Lire ce document et `pilotage/AVANCEMENT_CORRECTIONS_V31.md`, `pilotage/BILAN_REVUE_V3.1.md`, puis les issues #1 à #16.
2. Lire l'état **actuel** de la PR #17 et les derniers runs GitHub Actions (ne pas considérer ce fichier comme une preuve de tests postérieurs).
3. Vérifier le dernier commit de `main` et la dernière sauvegarde (`versions/v3.1.1/`) avant toute opération risquée.
4. Continuer uniquement dans la branche de développement ou une PR non publiée, en conservant les fichiers `data/entries_v2.json` et `data/photos_v2.json` comme base éditoriale.
5. Consigner dans la PR, les tickets et ce registre ce qui est **codé**, **testé** ou **validé** — trois états différents.
6. Ne pas fusionner des développements futurs dans `main` sans une décision utilisateur explicite ; la publication intermédiaire du 11 novembre 2026 constitue une autorisation spécifique, pas une validation définitive de la V3.1.

## Décisions de gouvernance confirmées

- Séparation de trois surfaces : **application de consultation**, **laboratoire de tests**, **centre de pilotage en lecture seule**.
- Pas d'environnement de staging en ligne supplémentaire à ce stade ; utiliser branche, PR et sauvegardes régulières.
- Sauvegardes des deux pages HTML et trace du commit stable avant chaque publication, avec procédure de retour arrière.
- Validation requise pour les décisions historiques/esthétiques non arbitrées et avant **toute publication**.
- Architecture GitHub canonique, données JSON locales versionnées pour iOS, pas de synchronisation distante automatique.
- En native iOS, l'installation/signer, les App Groups et les essais iPhone exigent des vérifications qui ne sont pas remplacées par les tests statiques.

## Cycle technique lancé dans cette nouvelle conversation

- Ajout d'un job GitHub Actions macOS (XcodeGen + ressources embarquées + build unsigned iOS Simulator app/WidgetKit), en complément des contrôles Node.js Ubuntu.
- Ajout de `concurrency` pour annuler les runs devenus obsolètes quand un nouveau commit est poussé.
- Corrections de l'interface iOS : message d'erreur de ressource `entries_v2.json`, formulations plus prudentes sur sources et droits.
- WidgetKit : snapshot rapide sans réseau, schéma HTTPS obligatoire pour les photos distantes, citation longue non coupée au milieu du premier mot, libellé distinct pour événement.
- `.gitignore` évite de versionner les fichiers XcodeGen et ressources dérivées.
- Début de consultation documentaire de deux notices Wikimedia Commons (`p1920` et `p1918`) dans `data/photo_audit_v31.json` ; **statuts de droits et d'authenticité toujours non validés**.
- Le résultat du job macOS doit être vérifié dans l'onglet Actions de la PR. Ne jamais écrire « compilé » avant conclusion du build effectivement réussie.

## Priorités opérationnelles (ordre de travail)

| Rang | Action | Condition de sortie |
|---|---|---|
| P0 | Stabiliser CI macOS, résoudre erreurs de génération et compilation Xcode | Build iOS Simulator et WidgetKit vert sur le dernier commit |
| P0 | Confirmer absence de changement involontaire de `main` et restauration V3.1.1 | Version archivée et point de retour identifiés |
| P1 | Compléter thème et réglages natifs, routage et widgets | Code compilé ; tests appareils à organiser |
| P1 | Poursuivre audit des 24 médias et des 235 fiches | Sources traçables, droits et incertitudes distingués |
| P1 | Vérifier navigation photos, zoom/fermeture descendante, accessibilité | Recette Safari/iPhone documentée |
| P2 | Revue des couleurs Republic, fond photo et catégories thématiques | Arbitrages utilisateurs historiques/esthétiques |
| Avant sortie | Bilan de recette, double sauvegarde, demande de validation | Accord explicite du propriétaire avant fusion |

## Liens

- PR : https://github.com/okancitak18-cmd/ataturk-heritage/pull/17
- Actions : https://github.com/okancitak18-cmd/ataturk-heritage/actions
- Issues : https://github.com/okancitak18-cmd/ataturk-heritage/issues
- Main public : https://okancitak18-cmd.github.io/ataturk-heritage/
- Laboratoire : https://okancitak18-cmd.github.io/ataturk-heritage/laboratoire.html

**Note :** cette passation évolue ; toute affirmation de compilation, de droit photographique ou de validation historique doit être justifiée par un résultat spécifique, pas par la seule présence du code.
