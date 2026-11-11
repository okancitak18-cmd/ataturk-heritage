# Pilotage ATATÜRK Heritage

## Partage public en lecture seule

- La page `pilotage/index.html` est la version publique de consultation, sans saisie ni sauvegarde : https://okancitak18-cmd.github.io/ataturk-heritage/pilotage/
- Les visiteurs peuvent consulter les versions, appliquer des filtres et naviguer entre les dossiers.
- Les données affichées sont publiques dans `pilotage/data/*.json`. **Le dépôt est public**, ce qui permet de lire, copier et télécharger ces données.

## Édition

- L'ancien laboratoire d'édition locale est conservé dans `pilotage/edition/index.html`. Il ne permet pas d'écrire automatiquement sur GitHub, mais les changements locaux peuvent être exportés.
- La modification durable se fait dans GitHub, dans les fichiers `pilotage/data/*.json`, par une personne ayant les permissions nécessaires.
- La page d'édition est également techniquement publique : elle n'est pas un espace d'administration sécurisé. Ne jamais y placer de secret ni de données confidentielles.

## Sécurité

GitHub Pages publie des fichiers statiques. Un lien de consultation ne confère **aucun droit d'écriture** au dépôt GitHub. Les données ne doivent cependant pas être confidentielles, car un dépôt public est librement consultable. La prévention des contributions non autorisées dépend des droits GitHub et de la protection de la branche `main`, non du seul retrait des boutons d'édition.
