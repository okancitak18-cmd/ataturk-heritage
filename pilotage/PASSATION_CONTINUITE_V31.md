# ATATÜRK Heritage — passation de travail entre conversations

**Mise à jour initiale : 11 novembre 2026**  
**Dépôt :** `okancitak18-cmd/ataturk-heritage`  
**Développement :** `feature/v31-separation-app-laboratoire`, PR #17 en brouillon  
**Site public :** GitHub Pages déployé depuis `main` ; interdiction de fusion/publication sans validation explicite du propriétaire.

## Démarrage d'une nouvelle conversation

1. Lire ce document et `pilotage/AVANCEMENT_CORRECTIONS_V31.md`, `pilotage/BILAN_REVUE_V3.1.md`, puis les issues #1 à #16.
2. Lire l'état **actuel** de la PR #17 et les derniers runs GitHub Actions (ne pas considérer ce fichier comme une preuve de tests postérieurs).
3. Vérifier le dernier commit de `main` et la dernière sauvegarde (`versions/v3.1.1/`) avant toute opération risquée.
4. Continuer uniquement dans la branche de développement ou une PR non publiée, en conservant les fichiers `data/entries_v2.json` et `data/photos_v2.json` comme base éditoriale.
5. Consigner dans la PR, les tickets et ce registre ce qui est **codé**, **testé** ou **validé** — trois états différents.
6. Ne jamais fusionner dans `main` sans une décision utilisateur explicite, même si tous les contrôles CI réussissent.

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
