# Proposition de séparation — Application / Laboratoire

**Statut : POUR VALIDATION — ne pas fusionner sur `main` avant accord explicite du propriétaire.**

Cette branche transforme `index.html` en application publique orientée consultation sur iPhone **et sur ordinateur**. Les commandes de simulation, inspecteurs, paramètres techniques et textes de laboratoire sont retirés de la surface visible de l'application.

Le laboratoire complet `laboratoire.html` reste volontairement inchangé. Le tableau de bord public en lecture seule `pilotage/` reste inchangé.

## Avancement de la branche de développement

Les modifications suivantes sont **implémentées uniquement sur la branche de travail**, non publiées :

- **Séparation application / laboratoire** : interface publique épurée sur mobile et desktop ; outils techniques réservés à `laboratoire.html`.
- **Retour Archives** : bouton rond discret, meilleure hiérarchie et conservation du point de départ.
- **Photothèque (prototype V3.1)** : visionneuse sombre plein écran, navigation par groupe initial puis reste de la photothèque, zoom par double tap et pincement, notices à deux niveaux, bouton de fermeture et balayage **descendant (haut vers bas)**, retour préservant la position initiale.
- **Limite éditoriale** : les notices exploitent uniquement les métadonnées déjà présentes et doivent encore être enrichies et validées.

### État des vérifications
- Syntaxe JavaScript vérifiée après les modifications.
- Vérification statique des commandes, parcours et état d'ouverture/fermeture.
- **Pas de validation réelle Safari iPhone, pas de capture visuelle validée et pas de build SwiftUI natif.**
- Les déplacements tactiles, l'absence de conflits avec les gestes iOS, les images distantes et les cas d'échec de chargement sont à tester.

Ces éléments sont soumis à la revue du propriétaire **avant la fusion**.

## Itération suivante : laboratoire et apparence (11 novembre 2026)

**Intégré uniquement dans la branche de développement :**
- Même visionneuse photo dans le laboratoire et dans le prototype d'application : fond sombre, zoom pincement/double tap, parcours par période de départ puis catalogue restant, notice courte et détaillée, fermeture par balayage descendant.
- Préférences d'apparence indépendantes : application, widget d'accueil simulé, widget verrouillé simulé ; trois thèmes Heritage, Republic et Archive, chacun avec choix Clair / Sombre / Automatique selon le système.
- Application : icône discrète de réglages dans l'en-tête ouvrant un panneau ; pas d'ajout à la barre inférieure.
- Laboratoire : sélection de thème, apparence et préférences des trois surfaces, réinitialisation des choix et suivi des paramètres.
- Persistance locale par `localStorage` pour les préférences de présentation de la démonstration web.

**Réserves importantes :**
- Les collections photographiques actuellement testées sont des **groupes chronologiques provisoires inférés de l'année déclarée**, et non des collections éditoriales/thématiques scientifiquement validées.
- Le rouge `Republic` conserve sa palette provisoire, sans prétendre correspondre exactement au rouge des premiers drapeaux de la République.
- Les modes sombres sont des variantes CSS expérimentales ; ils n'intègrent pas le matériau natif Liquid Glass.
- Les préférences d'apparence des vrais widgets iOS (WidgetKit) restent à porter et tester dans un projet Xcode natif.
- Le laboratoire et l'app utilisent encore du code en grande partie dupliqué ; la mutualisation technique est une étape ultérieure.
- L'interface n'a pas encore bénéficié d'un test de rendu ou de gestes sur un iPhone réel. Les validations JavaScript réalisées sont **syntaxiques et structurelles uniquement**.
- **Aucune modification du site GitHub Pages public avant autorisation explicite** ; cette proposition n'est pas une demande de publication immédiate.

## Itération documentaire — index thématiques et dossiers historiques

**Livré uniquement sur la branche de travail (non publié)**

- **Galerie filtrable par thème** : les thèmes sont issus des fiches historiques déjà liées aux identifiants de photographies dans `data/entries_v2.json`. Le nombre de photos associées est calculé et les boutons permettent d'afficher chaque groupe. La visionneuse commence par le groupe choisi, puis poursuit dans le reste de la photothèque.
- **Dossiers Comprendre** : conservation du texte contextuel déjà présent, datation et précision, texte turc disponible, références du même thème et d'une période proche, source citée et notice de l'illustration.
- **Notice photographique approfondie** : métadonnées (période, provenance, dimensions si connues, déclaration de droits) et fiches du corpus réutilisant la même photographie ; pas d'affirmation que le document représente un événement donné.
- **Aucune nouvelle citation, date, attribution ou interprétation historique inventée.** Aucun champ historique source du référentiel modifié.
- **Interface et laboratoire** : fonctionnalités ajoutées dans les deux pages.

**Restrictions et validation éditoriale :**
Les groupes thématiques résultent de l'association existante `photoId` ↔ `theme` ; certains visuels servent d'illustration générique dans de nombreuses fiches. Ils doivent donc être compris comme des **index de navigation provisoires**, non comme des collections photographiques historiques vérifiées. Les notices restent à enrichir avec archives primaires, légendes exactes, acteurs, lieu, datation et droits. La catégorie « source déclarée » ne signifie pas « source auditée ».

**Contrôle effectué :** parsing JavaScript des deux pages, présence des 235 fiches historiques et de la photothèque ; pas de test visuel Safari/iPhone ni de validation des sources externes.

## Cycle de fiabilisation : widgets, animations et tests

- Simulations widgets d'accueil/verrouillage : les citations longues sont désormais montrées comme extraits identifiés. L'ordre des références dans la simulation est aligné sur le flux Aujourd'hui.
- Snapshot SwiftUI/WidgetKit : présentation courte par taille de widget et signalement explicite des extraits, sans compilation ni certification native.
- Animations web affinées, avec respect de `prefers-reduced-motion`.
- Vérification automatique : `scripts/check-v31.mjs` + workflow GitHub Actions sur la Pull Request. Contrôles de source JSON embarquée, liens de photographies, schémas de dates, JavaScript et éléments de navigation.
- Le suivi exhaustif de l'état, des limites et des décisions non prises est consigné dans `pilotage/AVANCEMENT_CORRECTIONS_V31.md`.

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
