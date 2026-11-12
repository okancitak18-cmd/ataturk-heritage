# ATATÜRK Heritage — état de la campagne de corrections V3.1

## Reprise des développements — 11 novembre 2026 (nouvelle conversation)

Les développements suivants sont **commités sur la branche non publiée** :

- **CI iOS Simulator** : job macOS/XcodeGen ajouté à la PR #17, génération des deux JSON locaux puis tentative de compilation non signée de l'application et de l'extension WidgetKit. Le résultat effectif de GitHub Actions doit être lu sur le **dernier commit** ; tant qu'un build n'est pas `success`, la compilation reste **non confirmée**.
- **Qualité de la livraison** : `.gitignore` pour exclure les projets Xcode générés, données de build et paquets JSON dérivés ; contrôle de concurrence pour éviter des runs macOS obsolètes.
- **SwiftUI / WidgetKit** : message correct pour `entries_v2.json`, prudence sur les attributions et licences, widget snapshot rapide sans réseau, chargement des médias HTTPS uniquement et extrait de citation sans coupe au milieu du premier mot.
- **Début de l'audit iconographique** : lecture des notices Commons `p1920` et `p1918` documentée séparément ; **aucune licence, authenticité ou redistribution approuvée**, 24 médias toujours en attente de validation de fond.
- **Continuité** : `pilotage/PASSATION_CONTINUITE_V31.md` recense décisions, liens, risques et ordre de travail entre conversations.

La vérification de build sur CI est distincte de l'installation sur iPhone ; un vrai test iOS et la signature Apple restent indispensables. Le site public `main` et son point de restauration V3.1.1 ne sont pas modifiés dans ce lot.

**Date :** 11 novembre 2026  
**Branche :** `feature/v31-separation-app-laboratoire`  
**Publication :** **non autorisée**, ne pas fusionner avant accord explicite du propriétaire.

## Réalisé dans la branche, non encore publié

| Priorité | Périmètre | État |
|---|---|---|
| P0 | Séparer application publique et laboratoire visuellement | Codé ; test visuel desktop/iPhone à faire |
| P0 | Conserver `data/entries_v2.json` et `data/photos_v2.json` en source de vérité | Cohérence stricte des données embarquées contrôlée, automatisation GitHub Actions en place |
| P1 | Archives : bouton retour plus discret et filtres préservés | Codé ; recette navigateur à faire |
| P1 | Photo immersive : zoom, fermeture descendante, notice à deux niveaux et collections provisoires | Codé sur les deux interfaces ; gestes iPhone à vérifier |
| P1 | Index photographiques thématiques | Codé sur les liens `photoId` existants ; associations **non encore auditées historiquement** |
| P1 | Dossier Comprendre : texte original, date, sources citées, documents associés | Codé sur le corpus ; analyses historiques longues encore à rédiger et valider |
| P1 | Heritage/Republic/Archive clair, sombre et automatique | Codé dans le web et le labo ; accessibilité et palette Republic à valider |
| P1 | Gestes et transitions plus visibles + `prefers-reduced-motion` | Codé ; ressenti iPhone à tester |
| P2 | Widget simulé : aperçu de texte long avec étiquette « Extrait » | Codé ; lisibilité par taille à tester |
| P2 | WidgetKit SwiftUI : préparation d'un composant de texte court | Source snapshot modifiée ; **pas de compilation iOS** |
| P2 | Contrôle automatisé de données et syntaxe | `scripts/check-v31.mjs` + workflow PR ; premiers runs GitHub Actions **réussis** |

## Étape suivante accomplie — fiabilisation des sources et socle iOS (11 novembre 2026)

- **24 photographies inventoriées** dans `data/photo_audit_v31.json` avec nombre de fiches liées, institution, licence déclarée et statut de vérification. **Zéro photographie approuvée pour redistribution** : droits, authenticité, date et disponibilité des liens restent à contrôler individuellement.
- **Données iOS embarquées** : `ios/v31_draft/Shared/ArchiveRepository.swift` charge les JSON locaux sans récupération distante automatique, conformément à la décision 31-10.
- **Générateur de ressources** : `scripts/package-ios-v31.mjs` copie les JSON sources dans un paquet local avec empreintes SHA-256 et budget textuel de 512 Kio ; les archives photographiques originales n'y figurent pas.
- **Point d'entrée de l'application et composants SwiftUI** : `ios/v31_draft/App/`.
- **Navigation native en brouillon** : deux App Intents précédent/suivant, état partagé App Group et deep link `ataturkheritage://entry/<id>`, codés dans `ios/v31_draft`.
- **Projet XcodeGen proposé** : `ios/v31_draft/project.yml`, à générer, configurer, signer et compiler sur Mac ; identifiants Apple et App Group proposés, **non provisionnés**.
- **Sauvegarde exacte** de la V3.1.1 actuellement publiée (application et laboratoire) sous `versions/v3.1.1/`, associée au commit stable `d4375729165e8ed9e70b45fb74ab65e86f214626`.
- **CI améliorée** : inventaire des photos, fabrication du paquet JSON et contrôles structurels du code natif, en plus des tests existants. Les contrôles structurels ne démontrent ni compilation iOS ni authenticité historique.

### Critères encore en suspens

Le vrai projet Xcode généré, la compilation et signature Apple, le comportement WidgetKit sur iPhone, l'intégration des photographies hors ligne et l'audit juridique des archives restent **non réalisés**. Les textes/données peuvent être embarqués sans connexion après intégration dans les cibles, mais la photothèque peut afficher un placeholder hors ligne.

## Décisions reportées / non tranchées

- **Rouge Republic historiquement authentifié** : choisir après vérification de sources originales et examen de variantes. Aucun hex « officiel 1923 » inventé.
- **Fond photographique noir vs légèrement flouté** : comparaison visuelle avant arbitrage.
- **Catégories historiques définitives et contexte géopolitique approfondi** : validation de sources par lot.
- **Poids des photographies hors ligne** : mesurer les fichiers optimisés avant décision sur les originaux embarqués.
- **WidgetKit natif / App Intents, deep link, thèmes indépendants** : un projet Xcode complet et un appareil réel sont encore nécessaires.
- **Publication et rollback** : archiver app + laboratoire, identifier commit stable, puis demander accord explicite avant fusion sur `main`.

## Comment vérifier

- GitHub CI : `.github/workflows/v31-checks.yml` exécute `node scripts/check-v31.mjs`.
- PR : `https://github.com/okancitak18-cmd/ataturk-heritage/pull/17`.
- Détails : `pilotage/PROPOSITION_SEPARATION_V3.1.md`.
- Ces contrôles ne remplacent **pas** les essais Safari/iPhone ni les audits de la photothèque.

## Étape avant la prochaine publication

Faire une revue consolidée des changements, comparer les palettes et les parcours, corriger les anomalies détectées, puis préparer une sauvegarde des deux HTML publics et un point de restauration. Ne pas fusionner la PR sans autorisation.
