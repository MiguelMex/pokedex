import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_species_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'package:pokedex/screens/pokemon_type_colors.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/screens/pokeon_detail_screen.dart';

//TODO: Change the future builder here to make it more modular
//TODO: Adjust views for better look

/// Renders the Pokédex-species attributes of a Pokémon:
/// description, profile, breeding, flags, and varieties.
///
///
/// Designed to be dropped into a [Column] on the detail screen.
class PokemonAttributesSection extends StatelessWidget {
  final PokemonSpeciesResponse species;
  final String primaryType;

  const PokemonAttributesSection({
    super.key,
    required this.species,
    required this.primaryType,
  });

  // ---------------- helpers ----------------

  // String _getPokemonDisplaySprite(String pkmName){
  //   final sprite = PokeApiProvider().getPokemonDislplay(species.id);
  //   return sprite.toString();
  // }

  int? _idFromUrl(String url){
    final match = RegExp(r'/(\d+)/?$').firstMatch(url);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  String _getUrl(String url){
    final id = _idFromUrl(url);
    final fullUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
    return fullUrl;
  }

  String _getGeneration(String gen){
    switch(gen){
      case 'generation-i': return 'I';
      case 'generation-ii': return 'II';
      case 'generation-iii': return 'III';
      case 'generation-iv': return 'IV';
      case 'generation-v': return 'V';
      case 'generation-vi': return 'VI';
      case 'generation-vii': return 'VII';
      case 'generation-viii': return 'VIII';
      case 'generation-ix': return 'IX';

      default: return 'No gen';
    }
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

  /// PokéAPI flavor text contains `\n` and `\f` (form feed).
  String _cleanFlavorText(String text) => text
      .replaceAll('\n', ' ')
      .replaceAll('\f', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  /// Prefer the newest English entry; falls back to any English entry.
  String _englishFlavorText() {
    final english = species.flavor_text_entries
        .where((e) => e.language['name'] == 'en')
        .toList();
    if (english.isEmpty) return 'No description available.';
    return _cleanFlavorText(english.last.flavor_text);
  }

  List _allEnglishFlavorText(){
    final english = species.flavor_text_entries.where((e) => e.language['name'] == 'en').toList();
    if (english.isEmpty) return ['No description available'];
    return english;
  }

  String _englishGenus() {
    final entry = species.genera
        .where((g) => g.language['name'] == 'en')
        .toList();
    return entry.isEmpty ? '—' : entry.first.genus;
  }

  List _allEnglishGenus() {
    final entry = species.genera
      .where((g) => g.language['name'] == 'en').toList();

    return entry.isEmpty ? ['No english entry'] : entry;
  }

  /// PokéAPI gender_rate is "eighths that are female".
  /// -1 = genderless, 0 = all male, 8 = all female.
  String _formatGenderRate(int rate) {
    if (rate == -1) return 'Genderless';
    final female = (rate / 8 * 100).round();
    final male = 100 - female;
    return '♂ $male%  /  ♀ $female%';
  }

  /// hatch_counter is in cycles; each cycle = 255 steps.
  String _formatHatchCounter(int counter) =>
      '${((counter + 1) * 255)} steps  (${counter + 1} cycles)';

  String _formatGrowthRate() =>
      _capitalize((species.growth_rate['name'] as String? ?? '—')
          .replaceAll('-', ' '));

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
          const SizedBox(width: 12),
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

  Widget _sectionCard({required String title, required Widget child}) {
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

  // ---------------- build ----------------

  @override
  Widget build(BuildContext context) {
    final allGenus = _allEnglishGenus();
    final genus = _englishGenus();
    final flavor = _englishFlavorText();
    final allFlavor = _allEnglishFlavorText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Description ----
        _sectionCard(
          title: 'Pokédex Entry',
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                genus,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  itemCount: allFlavor.length,
                  itemBuilder: (context, index) {
                    final flavor = allFlavor[index];
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 8, color: getTypeBorder(primaryType)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 12),
                        child: Column(
                          spacing: 5,
                          children: [
                            Text(
                              _capitalize(flavor.version["name"]),
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                _cleanFlavorText(flavor.flavor_text),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    );
                  }),
              )
            ],
          ),
        ),

        // ---- Profile ----
        _sectionCard(
          title: 'Profile',
          child: Column(
            children: [
              _infoRow('Generation', _getGeneration(species.generation['name'])),
              _infoRow('Habitat', _capitalize(species.habitat?['name'] ?? 'Unknown')),
              _infoRow('Color', _capitalize(species.color['name'] ?? '—')),
              _infoRow('Shape', _capitalize(species.shape['name'] ?? '—')),
              _infoRow('Growth Rate', _formatGrowthRate()),
            ],
          ),
        ),

        // ---- Breeding ----
        _sectionCard(
          title: 'Breeding',
          child: Column(
            children: [
              _infoRow('Gender', _formatGenderRate(species.gender_rate)),
              _infoRow('Capture Rate', species.capture_rate.toString()),
              _infoRow('Base Happiness', species.base_happiness.toString()),
              _infoRow('Hatch Time', _formatHatchCounter(species.hatch_counter)),
              _infoRow(
                'Egg Groups',
                species.egg_groups.isEmpty
                    ? '—'
                    : species.egg_groups
                        .map((e) => _capitalize(e['name'] as String? ?? ''))
                        .join(', '),
              ),
            ],
          ),
        ),

        // ---- Varieties ----
       if (species.varieties.isNotEmpty)
        _sectionCard(
          title: 'Other forms',
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 80, // card padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // ← centers when few
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: species.varieties.map((variety) {
                    final pokemonUrl = variety.pokemon['url'] as String;
                    final id = _idFromUrl(pokemonUrl);
                    final spriteUrl = id == null
                        ? null
                        : 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PokemonDetailScreen(pokemonName: variety.pokemon['name'],),),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (spriteUrl != null)
                              Image.network(spriteUrl, width: 80, height: 80, fit: BoxFit.contain),
                            const SizedBox(height: 10),
                            Text(_capitalize(variety.pokemon['name'].toString())),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),

        // ---- Evolves From ----
        if (species.evolves_from_species != null)
          _sectionCard(
            title: 'Pre evolution',
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PokemonDetailScreen(pokemonName: species.evolves_from_species!["name"])),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsetsGeometry.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Image.network(_getUrl(species.evolves_from_species!["url"])),
                      Text(_capitalize(species.evolves_from_species!["name"])),
                    ],
                  ),
                ),
              ),
            )
          ),
      ],
    );
  }
}