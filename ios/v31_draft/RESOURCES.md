# Paquet local iOS V3.1

À partir des **sources uniques** de GitHub, générer les ressources embarquées dans les cibles app et WidgetKit :

```bash
node scripts/package-ios-v31.mjs --out .build/ios-resources
```

Le dossier de sortie comprend `entries_v2.json`, `photos_v2.json` et `content-manifest.json`, avec les empreintes SHA-256. Le paquet textuel et les métadonnées photographiques doivent rester sous **512 Kio** dans cette phase ; le poids des images originales n'entre pas dans ce budget.

Les données JSON ne sont pas modifiées dans ce processus, et **l'application ne télécharge pas de mises à jour automatiques**. Copier ou ajouter ces fichiers générés à Xcode au moment du build, pas dans une base concurrente.

**Vérification** : `.github/workflows/v31-checks.yml` réalise la génération dans un répertoire temporaire et contrôle les fichiers produits.

Les images sont encore référencées par URL : un mode avion garantit les textes et métadonnées après intégration, mais **pas la photographie hors connexion** avant sélection de fichiers licenciés et optimisés.
