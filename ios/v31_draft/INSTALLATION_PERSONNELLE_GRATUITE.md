# ATATÜRK Heritage — installation native personnelle gratuite, sans Mac

**Édition d'essai non publiée et non signée** : `project-personal.yml`, générée par GitHub Actions, est destinée à la **signature locale par AltStore Classic ou SideStore**. Ne jamais envoyer son mot de passe Apple à GitHub.

## Configuration

- Compte Apple **gratuit** suffisant pour le sideload personnel, sans Apple Developer Program à 99 USD/an.
- Pas de Mac possédé : GitHub Actions compile sur un runner macOS hébergé.
- **PC Windows nécessaire pour la configuration initiale d'AltStore Classic** (ou Windows/macOS/Linux pour SideStore, selon sa documentation).
- L'édition personnelle compile **l'application iOS SwiftUI sans extension WidgetKit**, sans entitlement App Group. Le flux journalier, la navigation, les favoris et les textes embarqués sont disponibles. Les photographies externes peuvent nécessiter Internet ; leur disponibilité et leur droit de réutilisation restent en cours d'audit.
- Les **vrais widgets** d'écran d'accueil/verrouillage restent dans le projet natif complet et seront testés séparément. Aucun widget n'est fourni dans l'IPA personnel.

## Étape 1 — récupérer l'IPA compilé dans GitHub

1. Ouvrir : https://github.com/okancitak18-cmd/ataturk-heritage/actions/workflows/ios-personal-ipa.yml
2. Choisir un run sur la branche `feature/v31-separation-app-laboratoire`, **terminé avec succès**.
3. Ouvrir le run, descendre jusqu'à **Artifacts**, puis télécharger `AtaturkHeritage-Personal-iPhone-unsigned`.
4. Décompresser l'archive téléchargée : elle contient `ATATURKHeritage-Personal-unsigned.ipa` et son SHA-256. Copier l'IPA dans l'app Fichiers de l'iPhone (AirDrop, iCloud Drive ou autre transfert personnel).
5. Si aucun run n'est vert ou qu'aucun artefact n'apparaît, **ne pas utiliser un IPA fictif** : consulter la page Actions pour l'erreur.

**Le fichier `.ipa` est non signé**. Un simple clic Safari sur le fichier ne peut pas installer l'app. La signature est effectuée localement, à partir du compte Apple du propriétaire, par le système de sideload choisi. Les artefacts GitHub expirent selon leur rétention (14 jours actuellement) ; il faut alors relancer un build.

## Étape 2 — AltStore Classic sur Windows

1. Lire les instructions officielles : https://faq.altstore.io/altstore-classic/how-to-install-altstore-windows
2. Installer sur Windows les prérequis Apple indiqués par AltStore (iTunes et iCloud téléchargés auprès d'Apple, de préférence les versions non Microsoft Store lorsque la documentation l'exige).
3. Télécharger **AltServer** depuis le site officiel : https://altstore.io/ . Ouvrir AltServer ; connecter l'iPhone au PC par câble, le déverrouiller et faire confiance à l'ordinateur.
4. Dans iTunes, activer la synchronisation Wi-Fi ; utiliser le menu AltServer pour **Install AltStore** sur l'iPhone.
5. Suivre les demandes de confiance des profils dans **Réglages > Général > VPN et gestion de l'appareil** et activer le **Mode développeur** dans Confidentialité et sécurité lorsque requis.
6. Sur l'iPhone, ouvrir AltStore Classic, se connecter au compte Apple de test, puis **My Apps > +** et sélectionner le fichier IPA depuis Fichiers.
7. Après la signature et l'installation locale, ouvrir l'icône ATATÜRK Heritage. L'application peut afficher les textes sans réseau grâce aux JSON embarqués.

**Renouvellement gratuit :** les installations personnelles expirent au bout de sept jours. AltStore peut rafraîchir avec AltServer allumé et sur le même Wi-Fi ou en USB ; ce n'est pas une installation permanente. Apple limite notamment à trois applications personnelles actives par appareil, AltStore occupant généralement un emplacement.

Ne saisir le mot de passe Apple que dans le flux d'authentification du logiciel installé depuis la source officielle. Vérifier l'origine du logiciel ; ne jamais publier identifiants Apple, certificats ou fichiers d'appairage sur GitHub.

## Variante SideStore (ordinateur principalement lors de l'installation initiale)

- Prérequis : https://docs.sidestore.io/docs/installation/prerequisites
- Installation : https://docs.sidestore.io/docs/installation/install
- SideStore requiert un ordinateur pour l'installation initiale et un profil d'appairage. Il peut ensuite renouveler l'app avec les exigences Wi-Fi/VPN de la documentation, sous réserve des changements d'iOS.
- Il reste soumis aux restrictions d'un compte Apple gratuit (expiration des profils, limites d'apps et d'App IDs).

## Ce qui est impossible dans ces conditions

- Il n'existe pas ici de **lien HTTPS universel donnant une installation native permanente sans signature ni compte développeur**.
- Une IPA **non signée** est un fichier à faire signer localement ; elle ne s'installe pas seule depuis Safari.
- Sans aucun accès à un PC/Mac/Linux (même temporaire), utiliser l'app web installable depuis Safari est la seule option actuellement opérationnelle dans le projet.
- La méthode gratuite n'offre pas TestFlight, un abonnement signé d'un an, ni une distribution Ad Hoc ouverte.

## État et traçabilité

Le workflow GitHub Actions `.github/workflows/ios-personal-ipa.yml` réalise un build Release réel `generic/platform=iOS`, copie `ATATURKHeritage.app` dans `Payload/` et crée une archive IPA non signée avec SHA-256. La disponibilité réelle n'est confirmée que lorsque le run est `success`. Une compilation ne vaut pas test fonctionnel sur l'appareil : contrôler la navigation, les images, les liens, le hors ligne et l'accessibilité après installation.

## Sources

- Apple Personal Team : https://developer.apple.com/fr/help/account/basics/about-your-developer-account/
- AltStore Classic Windows : https://faq.altstore.io/altstore-classic/how-to-install-altstore-windows
- AltStore renouvellement : https://faq.altstore.io/altstore-classic/your-altstore
- SideStore : https://docs.sidestore.io/docs/installation/prerequisites
