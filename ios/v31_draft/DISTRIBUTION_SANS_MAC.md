# Installer ATATÜRK Heritage sur iPhone sans posséder de Mac

**Date de vérification initiale : 11 novembre 2026.** Document de préparation ; il ne constitue **pas** un fichier IPA signé ni un lien natif déjà actif.

## État du projet

- Application web préversion V3.1 sur GitHub Pages : https://okancitak18-cmd.github.io/ataturk-heritage/
- PR #17 : code SwiftUI iOS / WidgetKit encore en développement ; `ios/v31_draft/project.yml` (XcodeGen).
- Compilation automatique iOS Simulator non signée sur runner GitHub Actions `macos-15` : **réussie**, run https://github.com/okancitak18-cmd/ataturk-heritage/actions/runs/43127593039 (Xcode 16.4, app et widgets).
- Aucun `.ipa` destiné à iPhone réel, signé et provisionné, n'a encore été produit.
- La version native requiert le traitement distinct des certificats/profils de **l'app ET de l'extension WidgetKit** et de la capacité App Group.

## Solution A — installation immédiate (web app / PWA)

1. Ouvrir le site public avec **Safari sur iPhone**.
2. Menu Partager → « Sur l'écran d'accueil ».
3. Activer « Ouvrir comme app web » si proposé, puis Ajouter.
4. Démarrer l'application par son icône.

**Sans Mac, sans abonnement développeur, sans App Store.** Fonctionne comme application web plein écran et non comme un binaire iOS natif. Les vrais widgets WidgetKit / App Intents ne peuvent pas fonctionner depuis la PWA. L'accès hors ligne et les photographies hébergées à distance ne sont pas garantis.

Référence Apple : https://support.apple.com/fr-ml/guide/iphone/iphea86e5236/ios

## Solution B — recommandée pour l'app native, TestFlight + compilation cloud

1. Vérifier l'abonnement **Apple Developer Program** actif (99 USD/an, prix local variable), via https://developer.apple.com/programs/ .
2. Dans Apple Developer, créer les identifiants explicites **application** et **extension WidgetKit**, ainsi que la capacité App Group partagée.
3. Depuis le navigateur, connecter le dépôt GitHub à un service macOS cloud : les runners GitHub Actions fonctionnent déjà pour la compilation non signée. Codemagic est une alternative avec configuration de certificats et profils sans Mac personnel, https://docs.codemagic.io/yaml-quick-start/building-a-native-ios-app/ .
4. Configurer **des identifiants et certificats privés dans les secrets du service**, jamais dans le dépôt public ou les messages. Signer l'application et l'extension pour la distribution **App Store Connect/TestFlight**.
5. Créer une fiche d'application dans App Store Connect, envoyer un IPA signé en utilisant le Mac cloud et attendre le traitement Apple.
6. Créer un groupe de testeurs ; pour une invitation externe par lien public, la première version doit subir la **Beta App Review** Apple. TestFlight installe ensuite la véritable app native sur l'iPhone, sans fiche publique sur l'App Store. Les widgets natifs peuvent être testés.

**TestFlight n'est pas une publication publique sur l'App Store**, mais utilise l'infrastructure d'Apple et nécessite l'installation de l'app TestFlight. La distribution interne est réservée aux membres éligibles de l'équipe App Store Connect ; un testeur externe peut être invité par courriel ou lien après l'examen bêta.

Références :
- https://developer.apple.com/testflight/
- https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers
- https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/

## Solution C — installer directement un IPA Ad Hoc via un lien HTTPS

Cette méthode évite TestFlight et l'App Store, mais **ne permet pas une installation libre sur n'importe quel iPhone**.

1. Disposer d'un abonnement Apple Developer Program actif et enregistrer l'**UDID** de l'iPhone dans le compte Apple Developer (ne pas utiliser de service d'UDID inconnu).
2. Créer deux App IDs explicites et profils **Ad Hoc** distincts, app et extension WidgetKit, associés au même certificat Apple Distribution et à l'App Group autorisée.
3. Dans un environnement macOS cloud, installer en **secrets** le certificat `.p12`, son mot de passe et les profils `.mobileprovision`. Générer le projet XcodeGen depuis les sources, remplacer les valeurs de démonstration `com.example.*` et `group.ataturkheritage.shared` par les identifiants réellement enregistrés.
4. Exécuter `xcodebuild archive` puis `xcodebuild -exportArchive` (export Ad Hoc), avec la signature de **chaque** cible.
5. Héberger de façon contrôlée l'`.ipa` et son manifeste OTA `.plist` en HTTPS, puis fournir le lien d'installation `itms-services://?action=download-manifest&url=<URL_HTTPS_DU_MANIFEST>`. Un simple lien de téléchargement du fichier `.ipa` ne suffit pas toujours à l'installer depuis Safari.
6. Sur l'iPhone enregistré, accepter l'installation et, si nécessaire, activer le mode développeur selon les exigences d'iOS.

**Attention :** le stockage du fichier IPA et son lien d'installation ne doivent pas exposer des secrets de signature ou ouvrir la distribution à des appareils non enregistrés. Ne pas publier de certificat/profil ni de clé privée sur GitHub Pages. Les droits de redistribution des photographies demeurent distincts de la signature Apple.

Références :
- https://developer.apple.com/help/account/provisioning-profiles/create-an-ad-hoc-provisioning-profile/
- https://developer.apple.com/documentation/xcode/distributing-your-app-to-registered-devices
- https://firebase.google.com/docs/app-distribution/register-additional-devices

## Comparaison

| Option | Mac personnel | Abonnement Apple payant | Vrais widgets iOS | Installation via iPhone | Statut |
|---|---|---|---|---|---|
| PWA Safari | Non | Non | Non | Sur l'écran d'accueil | Disponible maintenant |
| TestFlight + CI cloud | Non | Oui | Oui | Lien TestFlight après signature / approbation | À configurer |
| IPA signé Ad Hoc + lien HTTPS | Non, si CI cloud | Oui | Oui | Lien OTA, UDID préenregistré | À configurer |

### Bloqueur restant

**Le propriétaire doit confirmer s'il dispose d'un abonnement Apple Developer Program actif.** Sans accès à cette équipe de développeur ni les droits nécessaires, nous pouvons compiler à distance pour simulateur, mais ne pouvons pas fabriquer un IPA signé installable sur son iPhone. Les certificats, clefs privées, identifiants App Group et profils ne doivent jamais être demandés par une conversation en clair ; ils doivent être déposés directement dans le système de secrets du fournisseur de CI.

L'objectif est une installation native **hors publication publique App Store**. Une fois la voie TestFlight ou Ad Hoc choisie, elle doit être automatisée et testée sans prétendre que la signature est déjà acquise.
