# Audit des photographies V3.1

`data/photo_audit_v31.json` recense les **24 documents** du registre et leurs associations éditoriales. À sa création, **aucun document n'a été approuvé** pour une redistribution définitive ou hors ligne.

Pour chaque photo, vérifier manuellement l'authenticité visuelle, les métadonnées (date, lieu, participants), le crédit institutionnel, la notice source, la juridiction et les conditions de réutilisation. Vérifier l'existence effective des URLs, la meilleure résolution utilisable et documenter l'approbation.

Le champ `license` dans `data/photos_v2.json` est une **déclaration héritée**, pas un certificat d'autorisation. Les liens `photoId` identifient des associations dans notre corpus, pas des preuves d'identification historique de l'image.

```bash
node scripts/check-photo-audit-v31.mjs
```

Le script ne remplace pas l'audit manuel. Il détecte uniquement les fichiers manquants et les incohérences de suivi.
