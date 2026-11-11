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

## Politique de publication

Cette branche et sa PR ne sont pas le site GitHub Pages public. GitHub Pages publie encore `main`. Attendre confirmation du propriétaire avant fusion. Si une URL de prévisualisation isolée est souhaitée, elle nécessitera un environnement de staging indépendant.
