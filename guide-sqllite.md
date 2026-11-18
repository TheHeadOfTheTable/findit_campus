# Guide SQLite – FindIt Campus

Ce guide explique, avec des mots simples, comment l'application enregistre
maintenant les annonces dans une **base de données SQLite**.

---

## 1. Le problème de départ

Jusqu'ici, les annonces étaient rangées dans une simple liste Dart
(`List<LostItem>`). Cette liste vit dans la **mémoire vive** (RAM) du
téléphone.

👉 Quand on ferme l'application, la mémoire est vidée… et toutes les annonces
ajoutées disparaissent.

Pour garder les données, il faut les écrire **dans un fichier** sur le
téléphone. C'est exactement ce que fait SQLite.

---

## 2. SQLite, c'est quoi ?

**SQLite** est une petite base de données qui tient dans **un seul fichier**
(ici : `findit_campus.db`). Pas besoin de serveur ni d'Internet : tout reste
sur le téléphone.

On peut l'imaginer comme un **classeur Excel** :

| Terme SQLite | Équivalent Excel        | Dans notre appli                  |
|--------------|-------------------------|-----------------------------------|
| Base         | Le fichier `.xlsx`      | `findit_campus.db`                |
| Table        | Une feuille             | `items` (les annonces)            |
| Colonne      | Une colonne             | `title`, `location`, `date`…      |
| Ligne        | Une ligne               | Une annonce                       |
| Clé primaire | Un numéro unique        | `id` (deux annonces ≠ même `id`)  |

Exemple du contenu de la table `items` :

| id | title          | status | category     | location           | date                    | description |
|----|----------------|--------|--------------|--------------------|-------------------------|-------------|
| 1  | Sac à dos noir | lost   | Sacs         | Bibliothèque       | 2026-10-20T00:00:00.000 | …           |
| 2  | Clé USB bleue  | found  | Électronique | Salle informatique | 2026-10-21T00:00:00.000 | …           |

---

## 3. Le langage SQL en 4 phrases

Pour parler à la base, on utilise le langage **SQL**. Les 4 ordres de base :

| Action       | Ordre SQL | Exemple                                              |
|--------------|-----------|------------------------------------------------------|
| **C**réer    | `INSERT`  | `INSERT INTO items (id, title) VALUES ('5', 'Clés')` |
| **L**ire     | `SELECT`  | `SELECT * FROM items ORDER BY date DESC`             |
| **M**odifier | `UPDATE`  | `UPDATE items SET title = 'Clés' WHERE id = '5'`     |
| **S**upprimer| `DELETE`  | `DELETE FROM items WHERE id = '5'`                   |

On appelle souvent ça le **CRUD** (Create, Read, Update, Delete).

Dans ce TP, on utilise seulement **INSERT** (ajouter) et **SELECT** (lire).

---

## 4. Ce qu'on a ajouté au projet

### 4.1 Les paquets (`pubspec.yaml`)

```yaml
dependencies:
  sqflite: ^2.4.6   # SQLite pour Flutter
  path: ^1.9.1      # Pour construire le chemin du fichier .db
```

Commande utilisée pour les ajouter :

```bash
flutter pub add sqflite path
```

### 4.2 Les fichiers modifiés / créés

```
lib/
├── data/
│   ├── database_helper.dart   ← NOUVEAU : tout le code SQLite est ici
│   └── sample_items.dart      ← sert à remplir la base au 1er lancement
├── models/
│   └── lost_item.dart         ← ajout de toMap() et fromMap()
└── screens/
    └── home_screen.dart       ← lit la base au démarrage, écrit à l'ajout
```

Règle importante : **les écrans n'écrivent jamais de SQL**. Ils demandent
au `DatabaseHelper`, qui s'occupe de tout. Comme ça, si on change la base un
jour, on ne modifie qu'un seul fichier.

---

## 5. Étape par étape

### Étape 1 – Traduire une annonce pour SQLite (`lost_item.dart`)

SQLite ne comprend pas les objets Dart. Il ne connaît que du texte et des
nombres. On ajoute donc deux « traducteurs » à `LostItem` :

```dart
// Objet Dart  ➜  Map (pour ÉCRIRE dans la base)
Map<String, Object?> toMap() {
  return {
    'id': id,
    'title': title,
    'status': status.name,              // ItemStatus.lost ➜ "lost"
    'date': date.toIso8601String(),     // DateTime ➜ "2026-10-20T00:00:00.000"
    // ...
  };
}

// Map  ➜  Objet Dart (pour LIRE depuis la base)
factory LostItem.fromMap(Map<String, Object?> map) {
  return LostItem(
    id: map['id'] as String,
    status: ItemStatus.values.byName(map['status'] as String), // "lost" ➜ ItemStatus.lost
    date: DateTime.parse(map['date'] as String),               // texte ➜ DateTime
    // ...
  );
}
```

💡 Une `Map`, c'est une liste de paires **clé ➜ valeur**. Ici la clé est le
nom de la colonne, la valeur est le contenu de la case.

### Étape 2 – Ouvrir la base et créer la table (`database_helper.dart`)

```dart
openDatabase(
  path,             // où est le fichier .db
  version: 1,
  onCreate: (db, version) async {
    await db.execute('''
      CREATE TABLE items (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        ...
      )
    ''');
    // + on insère les 4 annonces d'exemple
  },
);
```

- `openDatabase` ouvre le fichier. **S'il n'existe pas, il le crée.**
- `onCreate` est appelé **une seule fois** : au tout premier lancement.
  C'est là qu'on crée la table et qu'on met les exemples.
- `TEXT` = texte, `PRIMARY KEY` = identifiant unique,
  `NOT NULL` = la case ne peut pas être vide.

### Étape 3 – Lire et écrire

```dart
// Lire toutes les annonces (SELECT)
final rows = await db.query('items', orderBy: 'date DESC');
return rows.map((row) => LostItem.fromMap(row)).toList();

// Ajouter une annonce (INSERT)
await db.insert('items', item.toMap());
```

`sqflite` écrit le SQL à notre place : `db.query(...)` génère un `SELECT`,
`db.insert(...)` génère un `INSERT`.

### Étape 4 – Brancher l'écran d'accueil (`home_screen.dart`)

```dart
@override
void initState() {
  super.initState();
  _loadItems();          // ① au démarrage : on lit la base
}

Future<void> _loadItems() async {
  final items = await DatabaseHelper.getItems();
  setState(() {
    _items = items;
    _isLoading = false;  // ② on cache le rond de chargement
  });
}
```

Et quand on ajoute une annonce :

```dart
await DatabaseHelper.insertItem(newItem);   // ③ on enregistre dans la base
setState(() => _items.insert(0, newItem));  // ④ on met à jour l'écran
```

---

## 6. Pourquoi `async` / `await` partout ?

Lire ou écrire un fichier prend un peu de temps (quelques millisecondes).
Si l'application attendait « bêtement », l'écran se figerait.

- `async` : « cette fonction peut prendre du temps ».
- `await` : « attends le résultat avant de passer à la ligne suivante,
  mais sans bloquer l'écran ».
- `Future<...>` : « une valeur qui arrivera plus tard ».

C'est pour ça qu'on affiche un `CircularProgressIndicator` (le rond qui
tourne) pendant la lecture.

---

## 7. Le chemin complet d'une annonce

```
 [Formulaire]  ──Enregistrer──▶  LostItem
                                    │
                                    ▼  toMap()
                               {'id': ..., 'title': ...}
                                    │
                                    ▼  db.insert()
                         ┌─────────────────────────┐
                         │  findit_campus.db        │  ← fichier sur le téléphone
                         │  table "items"           │
                         └─────────────────────────┘
                                    │
            (on ferme et relance l'appli)
                                    │
                                    ▼  db.query()
                               [{'id': ..., ...}, ...]
                                    │
                                    ▼  fromMap()
                              List<LostItem>  ──▶  [Liste à l'écran]
```

---

## 8. Tester

1. Lancer l'appli sur un **émulateur Android** ou un **téléphone** :
   ```bash
   flutter pub get
   flutter run
   ```
2. Ajouter une annonce.
3. **Fermer complètement** l'application (pas juste revenir en arrière).
4. La relancer ➜ l'annonce est toujours là ✅

⚠️ `sqflite` fonctionne sur **Android, iOS et macOS**. Sur Windows, Linux ou
le Web, la base n'est pas disponible : l'application affichera une liste vide
(un message d'erreur apparaît dans la console).

🔄 Pour **repartir de zéro** (retrouver les 4 exemples), désinstaller
l'application de l'émulateur : cela supprime le fichier `.db`.

---

## 9. Petit lexique

| Mot               | Signification simple                                          |
|-------------------|---------------------------------------------------------------|
| Persistance       | Le fait que les données restent après la fermeture de l'appli |
| Base de données   | Un endroit organisé pour ranger des données                   |
| Table             | Un tableau avec des colonnes et des lignes                    |
| Requête           | Une question/ordre envoyé à la base (en SQL)                  |
| Clé primaire      | Colonne qui identifie chaque ligne de façon unique            |
| `Map`             | Ensemble de paires clé ➜ valeur                               |
| `Future`          | Une valeur qui arrivera plus tard                             |
| `async` / `await` | Mots-clés pour attendre un `Future` sans bloquer l'écran      |
| `initState()`     | Méthode appelée une seule fois quand l'écran apparaît         |

---

## 10. Exercices pour aller plus loin

1. **Supprimer** une annonce : ajouter `deleteItem(String id)` dans
   `DatabaseHelper` avec `db.delete('items', where: 'id = ?', whereArgs: [id])`,
   puis un bouton 🗑️ dans l'écran de détail.
2. **Modifier** le statut (Perdu ➜ Trouvé) avec `db.update(...)`.
3. **Filtrer** : afficher seulement les objets trouvés avec
   `db.query('items', where: 'status = ?', whereArgs: ['found'])`.

💡 Le `?` dans `where` est remplacé par la valeur de `whereArgs`. C'est la
bonne façon de faire : on ne colle jamais directement du texte saisi par
l'utilisateur dans une requête SQL (risque d'« injection SQL »).
