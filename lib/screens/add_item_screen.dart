// Écran : formulaire pour ajouter une annonce (objet perdu ou trouvé).
// Quand on valide, on crée un LostItem et on le renvoie à l'écran d'accueil.

import 'package:flutter/material.dart';

import '../models/lost_item.dart';

// StatefulWidget : l'écran a un état qui change (le statut choisi).
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  // Clé du formulaire : sert à vérifier que tous les champs sont remplis.
  final _formKey = GlobalKey<FormState>();

  // Un contrôleur par champ : il permet de lire le texte tapé.
  final _title = TextEditingController();
  final _category = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();

  // Statut choisi (Perdu par défaut).
  ItemStatus _status = ItemStatus.lost;

  // Appelée automatiquement quand l'écran est fermé.
  // On libère les contrôleurs pour ne pas gaspiller de mémoire.
  @override
  void dispose() {
    _title.dispose();
    _category.dispose();
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  // Appelée quand on appuie sur le bouton "Enregistrer".
  void _save() {
    // validate() vérifie tous les champs.
    // Si un champ est vide, on s'arrête (les erreurs s'affichent en rouge).
    if (!_formKey.currentState!.validate()) return;

    // On crée l'annonce avec les valeurs saisies.
    final item = LostItem(
      // L'heure actuelle en millisecondes sert d'identifiant unique.
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _title.text,
      status: _status,
      category: _category.text,
      location: _location.text,
      date: DateTime.now(),
      description: _description.text,
    );

    // On ferme l'écran et on renvoie l'annonce à l'écran d'accueil.
    Navigator.pop(context, item);
  }

  // Petite fonction pour créer un champ de texte obligatoire.
  // Elle évite de répéter le même code 4 fois.
  // - controller : le contrôleur du champ
  // - label      : le texte affiché au-dessus du champ
  // - lines      : nombre de lignes minimum (1 par défaut)
  Widget _buildField(
    TextEditingController _controller,
    String _label, {
    int lines = 1,
  }) {
    return Padding(
      // Espace de 12 pixels en bas du champ.
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controller,
        minLines: lines, //Hauteur minimun du champ
        decoration: InputDecoration(
          labelText: _label,
          // Bordure autour du champ
          border: const OutlineInputBorder(),
          // Garde le label en haut pour les champs sur plusieurs lignes.
          alignLabelWithHint: lines > 1,
        ),
        // Vérification : renvoie un message d'erreur si le champ est vide,
        // sinon null (= le champ est valide).
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Champ obligatoire' : null,
      ),
    );
  }

  // build() dessine l'écran.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre du haut avec le titre de l'écran.
      appBar: AppBar(title: const Text('Ajouter une annonce')),
      // SingleChildScrollView : permet de faire défiler l'écran
      // (utile quand le clavier est ouvert).
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // Form regroupe les champs pour pouvoir les valider ensemble.
        child: Form(
          key: _formKey,
          // Column : place les éléments les uns sous les autres.
          child: Column(
            // stretch : les éléments prennent toute la largeur.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(_title, 'Titre'),

              // Menu déroulant pour choisir Perdu ou Trouvé.
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DropdownButtonFormField(
                  // Valeur affichée au départ.
                  initialValue: _status,
                  decoration: const InputDecoration(
                    labelText: 'Statut',
                    border: OutlineInputBorder(),
                  ),
                  // Les choix possibles du menu.
                  items: const [
                    DropdownMenuItem(
                      value: ItemStatus.lost,
                      child: Text('Perdu'),
                    ),
                    DropdownMenuItem(
                      value: ItemStatus.found,
                      child: Text('Trouvé'),
                    ),
                  ],
                  // Quand l'utilisateur change de choix, on met à jour
                  // le statut et setState() rafraîchit l'écran.
                  onChanged: (value) => setState(() => _status = value!),
                ),
              ),

              _buildField(_category, 'Catégorie'),
              _buildField(_location, 'Lieu'),

              // Description : au moins 5 lignes.
              _buildField(_description, 'Description', lines: 5),

              // Bouton qui appelle _save() quand on appuie dessus.
              ElevatedButton(
                onPressed: _save,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
