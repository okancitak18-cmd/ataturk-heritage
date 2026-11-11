# ATATÜRK Heritage — Centre de pilotage

Accès : https://okancitak18-cmd.github.io/ataturk-heritage/pilotage/

## Fichiers faisant foi

- `data/identite.json` : identité produit et principes
- `data/feuille-de-route.json` : objectifs par version, avec états et motifs
- `data/risques.json` : registre de suivi
- `data/ressources.json` : accès aux ressources
- `data/decisions.json` : décisions approuvées

## Procédure de modification

1. Modifier les champs ou les statuts dans le tableau de bord.
2. Exporter ou copier le JSON correspondant.
3. Ouvrir le fichier JSON sur GitHub et remplacer son contenu via le bouton d'édition, puis effectuer un commit (ou une pull request).
4. Actualiser le site et cliquer « Réinitialiser localement » si des valeurs locales anciennes masquent la version GitHub.

**Limite explicite :** une modification locale dans l'interface n'est pas automatiquement enregistrée dans GitHub ; seul le commit dans le dépôt constitue une mise à jour durable du projet pour les conversations suivantes.

## Validation

Un état « Fait » peut concerner uniquement la démo web. La validation finale exige une recette propre à la plateforme concernée. Le projet natif n'a pas encore été compilé sur iOS, et le registre historique attend une vérification éditoriale systématique.