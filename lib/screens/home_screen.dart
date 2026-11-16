// Fichier : screens/home_screen.dart
//
// Rôle : écran d'accueil de l'application. Il affiche la liste des annonces
// et gère l'ajout d'une nouvelle annonce dans l'état local.
//
// Pourquoi un `StatefulWidget` ici ?
// La liste des annonces change (ajout d'une annonce). Il faut donc un état
// mutable et appeler `setState()` pour rafraîchir l'affichage.
//
// Notions abordées :
// - `StatefulWidget` et `setState()` pour mettre à jour la liste ;
// - `ListView.builder` pour afficher une liste d'éléments ;
// - navigation avec `Navigator.push` / `Navigator.pop` ;
// - récupération d'un résultat renvoyé par un autre écran ;
// - gestion de l'état vide (liste vide).

import 'package:flutter/material.dart';

import '../data/sample_items.dart';
import '../models/lost_item.dart';
import '../widgets/item_card.dart';
import 'add_item_screen.dart';
import 'item_detail_screen.dart';

/// Écran d'accueil : liste des annonces + bouton d'ajout.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Liste des annonces affichées. On part d'une copie des données d'exemple
  // pour ne pas modifier la liste d'origine (`sampleItems`).
  final List<LostItem> _items = [...sampleItems];

  /// Ouvre l'écran d'ajout et récupère l'annonce créée.
  ///
  /// `Navigator.push` renvoie un `Future` : on utilise `await` pour attendre
  /// que l'écran suivant se ferme. Lorsqu'il se ferme avec
  /// `Navigator.pop(context, newItem)`, la valeur est transmise ici.
  Future<void> _openAddScreen() async {
    final newItem = await Navigator.push<LostItem>(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );

    // Si l'utilisateur a bien créé une annonce (et n'a pas juste fait "retour"),
    // on l'ajoute à la liste et on appelle `setState()` pour rafraîchir
    // l'affichage.
    if (newItem != null) {
      setState(() {
        // On insère en tête de liste pour voir la nouvelle annonce en premier.
        _items.insert(0, newItem);
      });
    }
  }

  /// Ouvre l'écran de détail pour l'annonce donnée.
  void _openDetail(LostItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemDetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FindIt Campus')),
      // Liste des annonces ou message si la liste est vide.
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'Aucune annonce pour le moment.\n'
                'Touchez le bouton + pour en ajouter une.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              // `itemCount` = nombre d'éléments à afficher.
              itemCount: _items.length,
              // `itemBuilder` est appelé pour chaque index.
              itemBuilder: (context, index) {
                final item = _items[index];
                return ItemCard(
                  item: item,
                  // Quand on touche la carte, on ouvre le détail.
                  // callback: () => _openDetail(item),
                  callback: () {
                    _openDetail(item);
                  },
                );
              },
            ),
      // Bouton flottant pour ajouter une annonce.
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddScreen,
        tooltip: 'Ajouter une annonce',
        child: const Icon(Icons.add),
      ),
    );
  }
}
