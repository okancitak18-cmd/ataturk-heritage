# ATATÜRK Heritage — Publication web de la V3.1

## Pages du site

- `index.html` : expérience de consultation immersive sur Safari iPhone **et ordinateur**, sans commandes de simulation visibles.
- `laboratoire.html` : environnement séparé de simulation, avec sélecteur de date, thèmes, aperçu des widgets et inspecteur historique.
- `manifest.webmanifest` et `icon-*.png` : icônes et possibilité facultative d’ajout à l’écran d’accueil (aucune installation requise pour consulter le site).

**Configuration initiale** : application, thème Heritage, 29 octobre 2026. Les `?mode=app&theme=heritage&date=2026-10-29` sont pris en charge.

## Publication GitHub Pages (recommandée pour les mises à jour)

1. Se connecter à GitHub et créer un dépôt **public** nommé `ataturk-heritage`.
2. Dans le dépôt, utiliser **Add file > Upload files**, et envoyer **tous les fichiers du présent dossier** (le fichier `index.html` doit se trouver à la racine). Commiter sur la branche `main`.
3. Ouvrir **Settings > Pages > Build and deployment > Source > Deploy from a branch**.
4. Sélectionner `main` et `/ (root)`, puis **Save**.
5. Lorsque GitHub Pages indique le déploiement terminé, ouvrir `https://VOTRE-COMPTE.github.io/ataturk-heritage/`.
6. Ouvrir `/laboratoire.html` pour retrouver l'interface complète de validation.

Cette URL est un **exemple de format**, pas une URL publiée ou vérifiée.

## Publication alternative sans GitHub

Envoyer ce ZIP ou ce dossier à https://app.netlify.com/drop ; le service attribue ensuite une URL publique. Les pages peuvent être mises à jour en redéployant la version suivante.

## Vérifications sur iPhone

- Dans Safari, ouvrir l'URL racine : l'interface se déploie sur l'écran, sans cadre d'iPhone simulé.
- Appuyer sur `⚙ Réglages` pour changer de date, de thème et de vue ; voir les widgets simulés.
- Tester la recherche, les favoris, le défilement tactile, les liens de provenance et la galerie.
- Ouvrir `laboratoire.html` pour l'inspecteur historique et la liste des points à valider.

## Limites et points de vigilance

- Les photographies d'archives sont hébergées par des institutions externes : leur chargement dépend de leur disponibilité, de l'accès réseau et des restrictions de ces sites. Elles ne sont pas intégrées au dépôt ni inventées par IA.
- Le site est un prototype *public* ; les données historiques ne constituent pas encore une édition définitive et les droits de réutilisation des images doivent être vérifiés avant diffusion élargie.
- Les modes widgets ne sont **que des simulations** sur le web et ne peuvent pas être ajoutés à l'écran verrouillé à partir de Safari. Pour de vrais widgets, il faut l'application SwiftUI/WidgetKit native.
- L'ajout facultatif à l'écran d'accueil iOS permet d'ouvrir le **site web** en mode application ; cela ne transforme pas le prototype en application native.
- Les pages portent l'indication robots « noindex » pour réduire leur référencement automatique.

Site public : https://okancitak18-cmd.github.io/ataturk-heritage/

## Installation immédiate sur iPhone (application web, sans App Store)

1. Dans **Safari iPhone**, ouvrir https://okancitak18-cmd.github.io/ataturk-heritage/ .
2. Dans le menu de la page, sélectionner **Partager > Sur l'écran d'accueil**.
3. Activer **Ouvrir comme app web**, puis **Ajouter**.
4. Ouvrir l'icône *Heritage* sur l'écran d'accueil.

Il s'agit d'une **web app** (PWA) et non d'une app iOS SwiftUI signée. Les widgets système WidgetKit et les App Intents natifs ne sont **pas** disponibles dans la PWA. Les contenus textuels sont incorporés dans le HTML, mais **le chargement hors connexion n'est pas garanti sans mise en cache préalable** ; les photos restent soumises à l'accès réseau et aux licences. Cette installation n'ajoute ni application via App Store ni binaire IPA.

## Livraison iOS native sans Mac personnel

Le build iOS Simulator non signé de la branche de développement a passé GitHub Actions sur macOS hébergé (run 43127593039). Pour installer un vrai IPA via lien, il faudra un compte Apple Developer actif, les deux identifiants et App Group, les certificats et profils de provisioning correspondant à l'app **et** aux widgets, et l'UDID de l'iPhone pour une distribution Ad Hoc. Préférer TestFlight si plusieurs testeurs ont besoin de liens sans renseigner les UDID. Aucun IPA signé ou lien d'installation native n'est encore disponible.
