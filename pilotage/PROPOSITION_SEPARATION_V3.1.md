# Proposition de séparation — Application / Laboratoire

**Statut : POUR VALIDATION — ne pas fusionner sur `main` avant accord explicite du propriétaire.**

Cette branche transforme `index.html` en application publique orientée consultation sur iPhone **et sur ordinateur**. Les commandes de simulation, inspecteurs, paramètres techniques et textes de laboratoire sont retirés de la surface visible de l'application.

Le laboratoire complet `laboratoire.html` reste volontairement inchangé. Le tableau de bord public en lecture seule `pilotage/` reste inchangé.

## Périmètre

- Affichage plein écran du musée sur toutes les largeurs d'écran ; pas de maquette de téléphone entourée de panneaux de simulation.
- Conservation des parcours Aujourd'hui, Archives, Photos et Favoris, des gestes V3.1.1, du partage et du contexte historique.
- Date de l'écran Aujourd'hui déterminée par la date locale du navigateur, non par la date de test du laboratoire.
- Aucune nouvelle photographie, citation ou notice ; corpus inchangé.
- Aucun portage natif SwiftUI/WidgetKit compris dans cette proposition.
- Mode de prévisualisation et sélecteur de dates réservés au laboratoire ; aucune évolution du laboratoire dans ce premier lot.

## Vérifications statiques

- Analyse syntaxique JavaScript : effectuée.
- Contrôles de présence des 235 fiches, 24 documents visuels et de la navigation : effectués.
- Recette visuelle réelle sur Safari iPhone et navigateur desktop : **à effectuer avant fusion**.
- Vérification de bonne présentation du contenu long, du clavier, des favoris et des gestes : **à effectuer avant fusion**.

## Politique de sauvegarde et de revue (simplifiée — décision du propriétaire)

**Pas d'environnement de prévisualisation hébergé séparément à ce stade.** Le coût d'exploitation et la complexité ne sont pas justifiés.

- Conserver le développement sur une branche et une Pull Request, afin que `main` et les liens publics restent inchangés durant la préparation.
- Contrôler la syntaxe, les données et les interactions ; fournir une description claire des modifications et de leurs limites, sans prétendre avoir réalisé des tests visuels non effectués.
- Avant chaque fusion sur `main`, archiver **l'état de l'application ET du laboratoire** (par exemple dans `versions/<version>/`) et identifier le commit ou tag Git du point de retour.
- Conserver au moins une copie de la version stable immédiatement précédente ; garder un historique des versions significatives et un changelog.
- Demander et attendre l'accord explicite du propriétaire pour publier les changements visibles. GitHub Pages restera publié depuis `main` et se mettra à jour automatiquement lorsque la fusion approuvée aura lieu.
- Vérifier les deux liens publics après publication ; en cas d'échec, utiliser la version archivée ou le commit précédent pour revenir à l'état stable.
- Le staging en ligne restera une option future, uniquement si les risques et la fréquence de publication le justifient.

## Politique de publication

Cette branche et sa PR ne sont pas le site GitHub Pages public. GitHub Pages publie encore `main`. Attendre confirmation du propriétaire avant fusion. Si une URL de prévisualisation isolée est souhaitée, elle nécessitera un environnement de staging indépendant.
