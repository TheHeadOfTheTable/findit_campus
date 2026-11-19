// Fichier : data/database_helper.dart
//
// Rôle : centraliser TOUT ce qui concerne la base de données SQLite.
// Les écrans n'écrivent jamais de SQL eux-mêmes : ils appellent simplement
// `DatabaseHelper.getItems()` ou `DatabaseHelper.insertItem(item)`.
//
// Pourquoi SQLite ?
// Avant, les annonces étaient seulement en mémoire : elles disparaissaient
// quand on fermait l'application. SQLite enregistre les données dans un
// fichier sur le téléphone, elles sont donc conservées.
//
// Notions abordées :
// - package `sqflite` : utiliser SQLite dans Flutter ;
// - `openDatabase` : ouvrir (ou créer) le fichier de la base ;
// - `onCreate` : créer la table la première fois ;
// - requêtes `insert` et `query` ;
// - `async` / `await` : les accès à la base prennent du temps.
//
// Voir aussi le fichier `guide-sqllite.md` à la racine du projet.

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/lost_item.dart';
import 'sample_items.dart';

class DatabaseHelper {
  // Nom du fichier de la base de données sur le téléphone.
  static const String _databaseName = 'findit_campus.db';

  // Nom de la table qui contient les annonces.
  static const String tableItems = 'items';

  // La base est ouverte une seule fois puis gardée ici.
  // `?` : elle vaut `null` tant qu'on ne l'a pas encore ouverte.
  static Database? _database;

  /// Renvoie la base de données (l'ouvre si ce n'est pas encore fait).
  static Future<Database> get database async {
    // Si la base est déjà ouverte, on la renvoie directement.
    if (_database != null) return _database!;

    // Sinon on l'ouvre et on la garde pour les prochaines fois.
    _database = await _openDatabase();
    return _database!;
  }

  /// Ouvre le fichier de la base. S'il n'existe pas, il est créé.
  static Future<Database> _openDatabase() async {
    // Dossier où Android/iOS rangent les bases de données de l'appli.
    final folder = await getDatabasesPath();
    // Chemin complet du fichier, ex. ".../databases/findit_campus.db".
    final path = join(folder, _databaseName);

    return openDatabase(
      path,
      // Numéro de version de la structure de la base.
      // À augmenter si un jour on modifie la table.
      version: 1,
      // `onCreate` n'est appelé QU'UNE SEULE FOIS : quand le fichier
      // n'existe pas encore (premier lancement de l'appli).
      onCreate: (db, version) async {
        // 1. On crée la table (comme un tableau Excel avec des colonnes).
        await db.execute('''
          CREATE TABLE $tableItems (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            status TEXT NOT NULL,
            category TEXT NOT NULL,
            location TEXT NOT NULL,
            date TEXT NOT NULL,
            description TEXT NOT NULL
          )
        ''');

        // 2. On ajoute les annonces d'exemple pour ne pas démarrer à vide.
        for (final item in sampleItems) {
          await db.insert(tableItems, item.toMap());
        }
      },
    );
  }

  /// Lit toutes les annonces, de la plus récente à la plus ancienne.
  ///
  /// Équivaut à : SELECT * FROM items ORDER BY date DESC
  static Future<List<LostItem>> getItems() async {
    final db = await database;
    // `query` renvoie une liste de lignes. Chaque ligne est une Map
    // (ex. {'id': '1', 'title': 'Sac à dos noir', ...}).
    final rows = await db.query(tableItems, orderBy: 'date DESC');
    // On transforme chaque ligne en objet `LostItem`.
    return rows.map((row) => LostItem.fromMap(row)).toList();
  }

  /// Enregistre une nouvelle annonce dans la base.
  ///
  /// Équivaut à : INSERT INTO items (id, title, ...) VALUES (...)
  static Future<void> insertItem(LostItem item) async {
    //Connexion à la base de données
    final db = await database;

    // On insère l'annonce dans la table. `item.toMap()` transforme
    // l'objet `LostItem` en Map (ex. {'id': '1', 'title': 'Sac à dos noir', ...}).
    await db.insert(tableItems, item.toMap());
  }
}
