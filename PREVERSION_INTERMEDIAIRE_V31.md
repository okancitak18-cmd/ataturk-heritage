# ATATÜRK Heritage — préversion intermédiaire V3.1

**Publication autorisée par le propriétaire le 11 novembre 2026.** Cette diffusion publique est **intermédiaire et non une validation finale V3.1**.

## Périmètre diffusé
- `index.html` : application web de consultation épurée (mobile/desktop), issue de la branche `feature/v31-separation-app-laboratoire`.
- `laboratoire.html` : laboratoire de simulation séparé, depuis la même branche.
- `pilotage/` : centre de pilotage public conservé dans l'état publié ; pas de déploiement du code SwiftUI ou des scripts de recherche.
- Manifeste PWA corrigé : démarrage à la date courante de l'application au lieu d'une date codée en dur.

## Protection et retour arrière
- Point de restauration de la version précédente : commit `d4375729165e8ed9e70b45fb74ab65e86f214626`.
- Sauvegarde exacte des fichiers publics précédents : `versions/v3.1.1/index.html` et `versions/v3.1.1/laboratoire.html`.
- Sauvegarde du nouvel état web : `versions/v3.1-intermediaire/index.html` et `versions/v3.1-intermediaire/laboratoire.html`.
- Le retour arrière peut être effectué par un commit rétablissant les deux HTML de V3.1.1 ainsi que son manifeste, sans réécrire brutalement l'historique.

## Contrôles et limites
- La PR #17 disposait de tests statiques et d'un build iOS Simulator **réussis** avant cette publication ; les fichiers HTML déployés sont réutilisés à l'identique depuis cette branche.
- Vérification de rendu iPhone, gestes, accessibilité et photothèque historique **non encore validées** sur téléphone réel.
- 235 fiches (48 citations, 187 événements), 24 photographies ; sources, dates et droits exigent vérification continue. Les notices de licences héritées ne constituent pas une autorisation de redistribution.
- L'expérience iPhone via écran d'accueil est **une web app** ; elle n'installe pas de widgets WidgetKit ni le binaire natif.
- Aucun IPA signé n'est publié. Une nouvelle version pourra être publiée après validation complète de V3.1.

## Liens
- Application : https://okancitak18-cmd.github.io/ataturk-heritage/
- Laboratoire : https://okancitak18-cmd.github.io/ataturk-heritage/laboratoire.html
- Pilotage : https://okancitak18-cmd.github.io/ataturk-heritage/pilotage/
- Développement en cours : https://github.com/okancitak18-cmd/ataturk-heritage/pull/17
