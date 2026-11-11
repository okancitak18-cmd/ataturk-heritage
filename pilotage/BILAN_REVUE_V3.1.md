# ATATÜRK Heritage — Bilan consolidé de la revue V3.1

**Date de revue :** 11 novembre 2026  
**Statut :** revue fonctionnelle complète (12/12 objectifs), **version V3.1 non validée**.  
**Version web actuelle :** V3.1.1 (préversion), avec quelques corrections déjà intégrées.  
**Validation de publication :** toute **nouvelle évolution visible** de l'application ou du laboratoire requiert l'accord préalable explicite du propriétaire.

## 1. Diagnostic confirmé

- **Application publique :** `index.html` / https://okancitak18-cmd.github.io/ataturk-heritage/  
  Sur iPhone, rendu plein écran ; sur ordinateur, trop proche du laboratoire. Doit devenir une interface destinée aux utilisateurs, sans inspecteur ni outils de simulation dans l'expérience normale.
- **Laboratoire interne de consultation :** `laboratoire.html` / https://okancitak18-cmd.github.io/ataturk-heritage/laboratoire.html  
  Prévisualisation des modes application / widget accueil / widget verrouillage, choix des thèmes, dates simulées, tests, comparaison d'options, inspecteur.
- **Feuille de route publique, lecture seule :** `pilotage/index.html` / https://okancitak18-cmd.github.io/ataturk-heritage/pilotage/#roadmap  
  Outil de communication et suivi, ne confère pas de droit d'écriture au dépôt.
- **Édition officielle :** commits GitHub des fichiers `pilotage/data/*.json`, réalisés par les comptes disposant des droits. L'éditeur local `pilotage/edition/` n'est pas une interface privée/authentifiée.

### Réalité technique

L'application et le laboratoire partagent encore un moteur et des données embarquées. Le site GitHub Pages est **automatiquement republié à chaque commit sur `main`**, tant que cette source de déploiement reste sélectionnée. **L'accord humain préalable doit être appliqué via branches/PR et, idéalement, protections de branche ou déploiement manuel. Ce verrouillage technique n'a pas encore été activé.** Le présent commit met à jour la gouvernance et le bilan, pas le design du produit.

## 2. Résultats de revue objectif par objectif

| Objectif | Décision de revue | Synthèse | Suivi |
|---|---|---|---|
| 31-1 Interface et gestuelle | À approfondir | DA Heritage, widgets et proportions appréciés. Renforcer animations, évaluer Liquid Glass **natif** ; gestes web jugés satisfaisants. | [#5](https://github.com/okancitak18-cmd/ataturk-heritage/issues/5) |
| 31-2 Date / éphéméride | À approfondir | Sélecteur date **laboratoire seulement**. Chronologie web V3.1.1 satisfaisante ; vérifier dates, fallback et comportement natif. | [#6](https://github.com/okancitak18-cmd/ataturk-heritage/issues/6) |
| 31-3 Navigation / compréhension | À corriger | Retour depuis Archives et filtres améliorés en V3.1.1 ; raffiner le bouton. Contextes à enrichir et sourcer. Aide gestuelle discrète, partage et icônes améliorés. | [#7](https://github.com/okancitak18-cmd/ataturk-heritage/issues/7) |
| 31-4 Photothèque | À corriger | Grille conservée, tester masonry ; notices riches et fiables, collections thématiques/chronologiques, qualité et droits. | [#8](https://github.com/okancitak18-cmd/ataturk-heritage/issues/8) |
| 31-5 Thèmes | À corriger | Heritage par défaut ; clair/sombre sur les trois thèmes ; Republic rouge vintage fondé sur source documentée (pas de faux code exact 1923) ; Archive conservé. | [#9](https://github.com/okancitak18-cmd/ataturk-heritage/issues/9) |
| 31-6 Widgets simulés | À corriger | Éviter les textes tronqués/trompeurs ; taille **moyenne rectangulaire** privilégiée ; petit carré facultatif épuré ; verrouillage citation/événement puis date. | [#10](https://github.com/okancitak18-cmd/ataturk-heritage/issues/10) |
| 31-7 Widget interactif | À approfondir | Précédent/suivant chronologiques, ouvrir la **fiche affichée**, sélection partagée, expérience widget principale unique sans promettre d'interdire les instances supplémentaires iOS. | [#11](https://github.com/okancitak18-cmd/ataturk-heritage/issues/11) |
| 31-8 Réglages | À approfondir | Icône discrète hors barre inférieure ; Clair / Sombre / Auto système ; préférences app / accueil / verrouillage indépendantes depuis l'app, sans aperçu obligatoire. | [#12](https://github.com/okancitak18-cmd/ataturk-heritage/issues/12) |
| 31-9 Visionneuse | À corriger | Plein écran sur noir ou sombre flouté à comparer, zoom pincement/double tap, collection puis photothèque, infos discrètes. **Fermeture par glissement du haut vers le bas**. | [#13](https://github.com/okancitak18-cmd/ataturk-heritage/issues/13) |
| 31-10 Données communes | À approfondir | GitHub source historique unique ; versions intégrées dans l'app, **sans mise à jour distante automatique pour l'instant** ; hors ligne souhaité selon taille ; revue éditoriale obligatoire. | [#14](https://github.com/okancitak18-cmd/ataturk-heritage/issues/14) |
| 31-11 Tests et accessibilité | À approfondir | Safari iPhone puis natif SwiftUI/WidgetKit ; accessibilité dès conception ; essai sur iPhone réel nécessaire pour **valider V3.1 globalement seulement** ; corrections groupées après la revue. | [#15](https://github.com/okancitak18-cmd/ataturk-heritage/issues/15) |
| 31-12 GitHub Pages | À corriger | Trois interfaces distinctes ; versions archivées ; **approbation explicite avant chaque nouvelle publication visible**. | [#16](https://github.com/okancitak18-cmd/ataturk-heritage/issues/16) |

**Bilan chiffré de la revue :** 12 objectifs examinés ; **6 décisions « À corriger »** (31-3, 31-4, 31-5, 31-6, 31-9, 31-12) et **6 « À approfondir »** (31-1, 31-2, 31-7, 31-8, 31-10, 31-11). Aucun objectif n'est définitivement validé au titre de la recette native V3.1. Le champ technique `a_valider` de la roadmap signifie **en attente de correction/validation**, pas « réussi ».

## 3. Campagne de corrections priorisée

### P0 — Gouvernance et socle, avant publication de nouvelles fonctions

**P0.1 — Publication sous contrôle (#16) :** développement sur branches ; proposition avec changelog, fichiers modifiés, captures et tests ; accord explicite du propriétaire ; fusion et publication **ensuite seulement**. Compléter avec une protection de `main` et/ou un workflow GitHub Pages à approbation manuelle. Tant que Pages déploie depuis `main`, aucun changement visible ne doit y être fusionné sans accord.

**P0.2 — Référentiel unifié et intégrité (#14, #4, #2, #3) :** identifier et versionner le schéma JSON source ; générer les données destinées au web et à iOS à partir du référentiel GitHub ; séparer les fiches vérifiées des brouillons. Ne pas intégrer comme faits des analyses géopolitiques non sourcées.

**P0.3 — Séparation des trois usages (#16) :** application publique réellement épurée sur mobile **et desktop**, laboratoire technique complet et tableau de bord public strictement consultatif ; liens explicites et navigation sans ambiguïté. Possibilité de réutiliser du code commun en interne, sans produire deux interfaces utilisateur identiques.

### P1 — Expérience immersive et archives (préversion visuelle à valider)

**P1.1 — Gestes, transitions et commandes (#5, #7) :** transitions iPhone plus naturelles, expérimenter Liquid Glass discret, conserver retour Archives/filtres, améliorer bouton retour ; accessibilité gestuelle et sans mouvement réduit.

**P1.2 — Photothèque immersive (#8, #13, #3) :** variante grille vs masonry, plein écran, zoom pinch/double tap, navigation collection puis globale, notice historique en deux niveaux, geste de fermeture **descendant** et bouton de secours ; audit provenance et droits ; aucune photo générée par IA.

**P1.3 — Dossiers historiques (#7, #2, #14) :** contexte, circonstances, acteurs et enjeux historiques ou géopolitiques documentés ; distinction faits/interprétations/incertitudes ; documents primaires et liens de preuve.

**P1.4 — Thèmes personnalisables (#9, #12) :** Heritage par défaut, Republic historique vintage validé, Archive conservé ; variantes claires/sombres et mode iOS automatique ; affichages indépendants pour widgets/application.

### P2 — Widgets natifs et recette globale

**P2.1 — Vrai projet Xcode (#1, #10, #11, #12) :** migration des sources SwiftUI/WidgetKit snapshot vers un projet compilable ; dimensions adaptées, éviter coupes de citations ; liens profonds et App Intents ; partage de l'état courant app/widgets.

**P2.2 — Éphéméride et hors ligne (#6, #14) :** vérifier dates exactes, contenus du jour et fallback ; précharger textes/métadonnées et photographies optimisées dans la limite d'un budget de taille mesuré ; actualisation par version uniquement à ce stade.

**P2.3 — Recette de version (#15) :** Safari iPhone puis application native ; VoiceOver, Dynamic Type, Safe Area, thèmes, motions, widgets, photographies, contraste et offline ; aucun test natif individuel exigé pour chaque objectif en cours de développement, mais **recette sur iPhone réel obligatoire avant validation générale V3.1**.

## 4. Ce qui est effectivement livré en V3.1.1 (ne pas confondre avec iOS)

- Geste horizontal et animations de démonstration web, effet de verre **CSS** (pas Liquid Glass système Apple).
- Flux web chronologique, sélection de date simulée dans laboratoire.
- Retour depuis Archives/Favoris, conservation des filtres, iconographie, partage web.
- Premiers repères de contexte provenant du corpus ; les notices historiques approfondies restent à rédiger.
- Application et laboratoire publiés, mais **visuellement trop proches sur desktop**.
- Pas de vrai projet Xcode complet compilé/testé ; les widgets du web sont des simulations.

## 5. Stratégie de publication approuvée

1. Toute nouvelle fonctionnalité visible est préparée sur une branche isolée, sans toucher à l'interface publique actuelle.
2. Fournir un **dossier de validation** : objectif(s), différence visuelle, impacts UX, changement de données, changelog, risques/test.
3. **Attendre la décision explicite de publication.** Une approbation générale de concept n'est pas une autorisation de publier une implémentation non présentée.
4. Archiver l'état précédent dans `versions/` ou tag Git ; créer la version approuvée et fusionner sur `main`.
5. Déployer Pages, vérifier les URL application/laboratoire/pilotage et noter le résultat. Si le contrôle technique de publication n'est pas encore disponible, faire respecter cette séquence manuellement ; **ne pas prétendre qu'une simple politique écrite désactive le déploiement automatique GitHub Pages**.

## 6. Conditions nécessaires à la validation définitive V3.1

- Toutes les corrections convenues regroupées, présentées puis approuvées ;
- données historiques et droits éditoriaux validés pour le périmètre diffusé ;
- séparation des trois expériences publiées ;
- tests d'accessibilité et de non-régression ;
- parcours natifs SwiftUI/WidgetKit réalisés sur iPhone physique ;
- version archivée, feu vert explicite du propriétaire.

**Prochaine étape :** élaborer la première branche de corrections consolidées et soumettre une préversion à validation **avant** toute modification visible du site GitHub Pages.
