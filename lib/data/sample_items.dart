// Fichier : data/sample_items.dart
//
// Rôle : fournir les annonces fictives affichées au démarrage de l'application.
// Ce fichier ne contient aucun widget : il ne fait que créer des instances
// de `LostItem`.
//
// Pourquoi un fichier séparé ?
// Pour séparer les données de l'interface. Si on veut modifier les exemples,
// on vient ici sans toucher aux écrans.
//
// Ces annonces sont copiées dans la base SQLite au tout premier lancement
// (voir `database_helper.dart`, méthode `onCreate`). Ensuite, c'est la base
// qui fait foi.

import '../models/lost_item.dart';

/// Liste des 4 annonces d'exemple affichées au lancement.
///
/// On utilise `final` (et non `const`) car les dates utilisent `DateTime`,
/// qui n'est pas toujours considéré comme constante dans ce contexte.
final List<LostItem> sampleItems = [
  LostItem(
    id: '1',
    title: 'Sac à dos noir',
    status: ItemStatus.lost,
    category: 'Sacs',
    location: 'Bibliothèque',
    date: DateTime(2026, 10, 20),
    description: 'Sac à dos noir avec un logo blanc, contenant des cours.',
  ),
  LostItem(
    id: '2',
    title: 'Clé USB bleue',
    status: ItemStatus.found,
    category: 'Électronique',
    location: 'Salle informatique',
    date: DateTime(2026, 10, 21),
    description: 'Clé USB de 32 Go de couleur bleue, trouvée sur un bureau.',
  ),
  LostItem(
    id: '3',
    title: 'Carte étudiant',
    status: ItemStatus.lost,
    category: 'Documents',
    location: 'Amphithéâtre A',
    date: DateTime(2026, 10, 22),
    description: 'Carte étudiant au nom de "Dupont".',
  ),
  LostItem(
    id: '4',
    title: 'Gourde rouge',
    status: ItemStatus.found,
    category: 'Accessoires',
    location: 'Cafétéria',
    date: DateTime(2026, 10, 23),
    description: 'Gourde rouge en métal, trouvée sur une table.',
  ),
];
