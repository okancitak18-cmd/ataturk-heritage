# Contrôles automatiques V3.1

Ce script vérifie que les deux préversions web utilisent **exactement** les 235 fiches et les 24 notices de `data/*.json`, sans dérive des identifiants, des dates et des associations photographiques.

```bash
node scripts/check-v31.mjs
```

Couverture : unicité des IDs, datation, associations `photoId`, présence de liens HTTPS, syntaxe JS, contrôles du prototype, absence de consignes permanentes. Ce sont des contrôles **structurels**. Ils ne vérifient **ni l'exactitude historique ni les droits de reproduction**, ni les gestes/taille du texte et la lisibilité réels sur iPhone.

Avant chaque fusion : exécuter ce script, documenter les corrections restantes, archiver les deux pages et attendre l'accord explicite du propriétaire.
