# ATATÜRK Heritage — état de la campagne de corrections V3.1

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
