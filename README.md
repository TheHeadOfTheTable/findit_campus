# FindIt Campus

Application mobile Flutter permettant aux étudiants de déclarer et consulter
des objets perdus ou trouvés sur le campus.

## Lancer le projet

```bash
flutter pub get
flutter analyze
flutter run
```

## Fonctionnalités

- Barre de navigation du bas avec 5 onglets : Accueil, Profil, À propos,
  Paramètres, Aide.
- Affichage d'une liste d'annonces (titre, catégorie, lieu, date, statut).
- Écran de détail d'une annonce.
- Formulaire d'ajout avec validation des champs obligatoires.
- Mise à jour immédiate de la liste après ajout.
- Écrans Profil, À propos, Paramètres et Aide.

## Concepts abordés

- `StatelessWidget` et `StatefulWidget`
- `setState()`
- `ListView.builder`
- Navigation avec `Navigator.push` / `Navigator.pop`
- Formulaires : `Form`, `GlobalKey<FormState>`, `TextFormField`, validators
- `TextEditingController` et `dispose()`

## Limites connues

Les données sont stockées uniquement en mémoire : elles disparaissent après
redémarrage de l'application. Il n'y a pas de backend, d'authentification ni
de persistance.
```
