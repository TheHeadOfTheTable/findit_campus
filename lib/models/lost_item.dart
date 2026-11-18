// Fichier : models/lost_item.dart
//
// Rôle : définir le modèle de données d'une annonce d'objet perdu/trouvé.
// Ce fichier ne contient aucun widget : il décrit uniquement la structure
// d'une annonce (ses champs et son constructeur).
//
// Pourquoi un modèle ?
// Plutôt que de passer des chaînes de caractères séparées, on regroupe
// toutes les informations d'une annonce dans un objet. C'est plus clair et
// plus facile à maintenir.
//
// Notions abordées :
// - création d'une classe Dart avec des champs `final` (immuables) ;
// - utilisation d'une énumération (`enum`) pour représenter un statut
//   limité à deux valeurs possibles (`perdu` ou `trouvé`) ;
// - constructeur avec paramètres nommés (`required`) ;
// - getter calculé (`formattedDate`).

/// Statut d'une annonce : l'objet est soit perdu, soit trouvé.
///
/// On utilise une énumération plutôt qu'une chaîne de caractères pour
/// éviter les fautes de frappe et limiter les valeurs possibles.
enum ItemStatus {
  lost,
  found;

  /// Libellé affiché à l'utilisateur (en français).
  String get label => this == ItemStatus.lost ? 'Perdu' : 'Trouvé';
}

/// Représente une annonce d'objet perdu ou trouvé sur le campus.
class LostItem {
  /// Identifiant unique de l'annonce (généré à partir de la date de création).
  final String id;

  /// Titre court de l'annonce (ex. "Sac à dos noir").
  final String title;

  /// Statut : perdu ou trouvé.
  final ItemStatus status;

  /// Catégorie de l'objet (ex. "Sacs", "Électronique").
  final String category;

  /// Lieu où l'objet a été perdu ou trouvé.
  final String location;

  /// Date de l'annonce.
  final DateTime date;

  /// Description libre de l'objet.
  final String description;

  /// Constructeur principal.
  ///
  /// Tous les champs sont obligatoires (`required`) pour garantir qu'une
  /// annonce est toujours complète.
  const LostItem({
    required this.id,
    required this.title,
    required this.status,
    required this.category,
    required this.location,
    required this.date,
    required this.description,
  });

  /// Retourne la date sous une forme simple et lisible : jj/mm/aaaa.
  ///
  /// C'est un getter : on l'utilise comme une propriété (`item.formattedDate`)
  /// alors qu'il calcule le résultat à la demande.
  String get formattedDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  // ---------------------------------------------------------------------
  // Conversion pour la base de données SQLite
  // ---------------------------------------------------------------------
  //
  // SQLite ne sait pas stocker un objet `LostItem` directement. Il ne connaît
  // que des valeurs simples : texte, nombres...
  // On transforme donc l'annonce en `Map` (clé = nom de la colonne,
  // valeur = contenu de la case) avant de l'enregistrer, et on fait
  // l'inverse quand on la relit.

  /// Transforme l'annonce en Map pour l'enregistrer dans la base.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      // L'enum est enregistré sous forme de texte : "lost" ou "found".
      'status': status.name,
      'category': category,
      'location': location,
      // La date est enregistrée sous forme de texte : "2026-10-20T00:00:00.000".
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  /// Recrée une annonce à partir d'une ligne lue dans la base.
  factory LostItem.fromMap(Map<String, Object?> map) {
    return LostItem(
      id: map['id'] as String,
      title: map['title'] as String,
      // "lost" -> ItemStatus.lost, "found" -> ItemStatus.found
      status: ItemStatus.values.byName(map['status'] as String),
      category: map['category'] as String,
      location: map['location'] as String,
      // Texte -> DateTime
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
    );
  }
}
