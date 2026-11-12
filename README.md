# ATATÜRK Heritage

**Musée historique personnel** dédié à la découverte et à la compréhension des citations, événements et archives de Mustafa Kemal Atatürk (1881–1938).

## Accès rapides

> **Préversion intermédiaire V3.1 publiée pour essais, non validée définitivement.** L'application web et le laboratoire sont séparés ; les archives et les visuels conservent leur statut de vérification éditoriale en cours. Les widgets visibles sur le web sont des simulations : le build iOS natif et l'installation nécessitent une distribution Apple signée. Voir [PREVERSION_INTERMEDIAIRE_V31.md](PREVERSION_INTERMEDIAIRE_V31.md).


- [Application web V3.1 — préversion intermédiaire](https://okancitak18-cmd.github.io/ataturk-heritage/) — démonstration mobile iPhone.
- [Laboratoire interactif](https://okancitak18-cmd.github.io/ataturk-heritage/laboratoire.html) — thèmes, dates, interfaces simulées.
- **[Centre de pilotage du projet](https://okancitak18-cmd.github.io/ataturk-heritage/pilotage/)** — fiche d'identité, feuille de route et gestion des décisions.
- [Guide de pilotage](pilotage/README.md) — comment faire évoluer le registre de référence.
- [Tickets et anomalies](https://github.com/okancitak18-cmd/ataturk-heritage/issues).

## État actuel

- Archives de la V2 : **235 références** (48 citations et 187 événements), **24 notices photographiques**.
- V3.1 : démonstration web mobile publiée ; widgets iOS simulés, pas installés.
- Natif : les sources SwiftUI et WidgetKit V2 sont partiellement archivées dans `ios/v2_snapshot` ; le projet Xcode complet reste à importer, compiler et tester.
- Les références, photographies et droits de reproduction exigent une revue complète avant publication publique définitive.

## Architecture du dépôt

```
index.html              Démonstration web iPhone
laboratoire.html        Laboratoire de prévisualisation
pilotage/               Gouvernance, identité, roadmap, décisions, risques
pilotage/data/          Fichiers JSON versionnés faisant foi
data/entries_v2.json    Registre V2 source (235 fiches)
data/photos_v2.json     Photothèque V2 source (24 notices)
ios/v2_snapshot/        Extraits SwiftUI / WidgetKit à compléter
```

Le code de l'application web et les métadonnées historiques sont distincts ; à terme, les deux interfaces doivent consommer un **référentiel commun**.

## Développement et validation

1. Suivre les objectifs et les risques dans [le tableau de bord](pilotage/).
2. Ouvrir un ticket pour toute correction ou modification majeure.
3. Enregistrer les décisions et changements de statut via un commit GitHub.
4. Tester le navigateur et la compilation native séparément.
5. Valider dates, attributions, licences, sources et conformité avant une distribution sur iPhone.

**Remarque :** les changements de champs effectués dans le tableau de bord sont d'abord locaux. Pour les rendre persistants et réutilisables entre conversations, exporter le fichier JSON modifié et le committer dans `pilotage/data/`.
