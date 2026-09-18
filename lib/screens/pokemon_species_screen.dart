import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_detail_response.dart';
import 'pokemon_type_colors.dart';

/// Renders the "extra" attributes of a Pokémon that aren't shown in the
/// main detail view: basic info, forms, species, game indices, moves
/// count, past abilities and past stats.
///
/// Designed to be dropped directly into a [Column] on the detail screen.
class PokemonAttributesSection extends StatelessWidget {
  final PokemonDetailResponse pokemon;
  final String primaryType;

  const PokemonAttributesSection({
    super.key,
    required this.pokemon,
    required this.primaryType,
  });

  // ---------- helpers ----------

  String _capitalize(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: getTypeColor(primaryType),
          border: Border.all(width: 4, color: getTypeBorder(primaryType)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
    // PokéAPI units:
    //   height -> decimeters  (7  => 0.7 m)
    //   weight -> hectograms  (69 => 6.9 kg)
    final heightMeters = pokemon.height / 10.0;
    final weightKg = pokemon.weight / 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Basic info ----
        _sectionCard(
          title: 'Basic Info',
          child: Column(
            children: [
              _infoRow('ID', '#${pokemon.id.toString().padLeft(3, '0')}'),
              _infoRow('Height', '${heightMeters.toStringAsFixed(1)} m'),
              _infoRow('Weight', '${weightKg.toStringAsFixed(1)} kg'),
              _infoRow('Base Experience', pokemon.base_experience.toString()),
              _infoRow('Order', pokemon.order.toString()),
              _infoRow('Default Form', pokemon.is_default ? 'Yes' : 'No'),
            ],
          ),
        ),

        // ---- Forms ----
        _sectionCard(
          title: 'Forms',
          child: pokemon.forms.isEmpty
              ? const Text('No alternate forms')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pokemon.forms
                      .map((f) => _infoRow('•', _capitalize(f.name)))
                      .toList(),
                ),
        ),

        // ---- Species ----
        _sectionCard(
          title: 'Species',
          child: _infoRow('Name', _capitalize(pokemon.species.name)),
        ),

        // ---- Game Indices (count only) ----
        _sectionCard(
          title: 'Game Indices',
          child: _infoRow(
            'Appearances',
            '${pokemon.game_indices.length} games',
          ),
        ),

        // ---- Moves (count only) ----
        _sectionCard(
          title: 'Moves',
          child: _infoRow('Total', '${pokemon.moves.length} moves'),
        ),

        // ---- Past Abilities ----
        _sectionCard(
          title: 'Past Abilities',
          child: pokemon.past_abilities.isEmpty
              ? const Text('None')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pokemon.past_abilities.map((p) {
                    final gen = p.generation["name"] ?? 'unknown';
                    final abilityNames = p.abilities
                        .map((a) => a.ability?["name"] ?? '—')
                        .join(', ');
                    return _infoRow(_capitalize(gen), abilityNames);
                  }).toList(),
                ),
        ),

        // ---- Past Stats ----
        _sectionCard(
          title: 'Past Stats',
          child: pokemon.past_stats.isEmpty
              ? const Text('None')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pokemon.past_stats.map((ps) {
                    final gen = ps.generation?["name"] ?? 'unknown';
                    final statList = ps.stats
                        .map((s) =>
                            '${_capitalize(s.stat["name"])}: ${s.base_stat}')
                        .join('\n');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _capitalize(gen),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(statList),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}