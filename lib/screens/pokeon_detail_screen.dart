import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/main.dart';
import 'package:pokedex/models/pokemon_detail_response.dart';
import 'package:pokedex/models/pokemon_species_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'abilities_detail_screen.dart';
import 'pokemon_species_screen.dart';
import 'pokemon_type_colors.dart';
import 'package:pokedex/helpers/audio_helper.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int? pokemonId;
  final String? pokemonName;
  const PokemonDetailScreen({super.key, this.pokemonId, this.pokemonName});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen>{
  String selectedSprite = '';
  List<String> spritesUrl = [];

  final PageController _spriteController = PageController();
  final List<String> _spriteUrls = [];
  int _currentSpriteIndex = 0;

  late final Future<http.Response> _pokemonFuture;
  late final Future<http.Response> _speciesFuture;

  final AudioPlayer _audioPlayer = AudioPlayer();
  
  //TODO: Adjust view so it doesn't shrink with more content

  @override
  void dispose(){
    _spriteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(widget.pokemonId != null){
      _pokemonFuture = PokeApiProvider().getPokemon(widget.pokemonId!);
    } else if (widget.pokemonName != null) {
      _pokemonFuture = PokeApiProvider().getPokemonByName(widget.pokemonName!);
    } else {
      return debugPrint('No pokemon selected');
    }
    
    _speciesFuture = _pokemonFuture.then((response) {
      final pokemon = PokemonDetailResponse.fromRawJson(response.body);
      return PokeApiProvider().getPokemonSpecies(pokemon.id.toString());
    });

    //play cry as soon as the data arrives
    _pokemonFuture.then((response) {
      if(!mounted) return;
      final pokemon = PokemonDetailResponse.fromRawJson(response.body);
      AudioHelper.instance.playSoundEffect(pokemon.cries.latest, true);
    }).catchError((_) {});
  }

  List<String> _extractSpriteUrls(PokemonDetailResponse response){
    final urls = <String>[];
    //final versions = response.sprites.versions;

    void addIfValid(dynamic value) {
      if (value is String && value.isNotEmpty && !urls.contains(value)){
        urls.add(value);
      }
    }

    final other = response.sprites.other;
    for(final category in const [
      'official-artwork',
      'home',
      'dream_world',
      'showdown',
    ]) {
      final entry = other[category];
      if (entry is Map){
        addIfValid(entry['front_default']);
        addIfValid(entry['front_shiny']);
      }
    }

    final versions = response.sprites.versions;
    final generations = versions.keys.toList().reversed;
    for (final gen in generations){
      final games = versions[gen];
      if(games is! Map) continue;
      for(final game in games.values){
        if(game is! Map) continue;
        addIfValid(game['front_default']);
        addIfValid(game['front_shiny']);
      }
    }

    return urls;
  }

  void _goToSprite(int index){
    if(index  < 0 || index >= _spriteUrls.length) return;
    _spriteController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  String _getStatName(String name){
    switch (name) {
      case 'hp': return 'HP';
      case 'attack': return 'Atk';
      case 'defense': return 'Def';
      case 'special-attack': return 'Sp-atk';
      case 'special-defense': return 'Sp-def';
      case 'speed': return 'Spd';

      default: return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pokemonName.toString()[0].toUpperCase()+widget.pokemonName.toString().substring(1),
          style: TextStyle(
            color: kBlackSoft,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Icon(
            Icons.catching_pokemon_sharp,
            color: Colors.white,
          ),
          SizedBox(width: 12,),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _pokemonFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'),);
            } else if (!snapshot.hasData){
              return const Center(child: Text('No data :('));
            } else {
              final pokemonResponse = PokemonDetailResponse.fromRawJson(snapshot.data!.body);
        
              final abilities = pokemonResponse.abilities;
        
              //TODO: Other chngable variables
              var stats = pokemonResponse.stats;
        
              if(_spriteUrls.isEmpty){
                _spriteUrls.addAll(_extractSpriteUrls(pokemonResponse));
              }
        
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.maxFinite,
                    child: Container(
                      decoration: BoxDecoration(
                        color: getTypeColor(pokemonResponse.types[0].type["name"]),
                        border: Border(bottom: BorderSide(width: 4, color: getTypeBorder(pokemonResponse.types[0].type["name"])))
                      ),
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _spriteController,
                            itemCount: _spriteUrls.length,
                            onPageChanged: (i) => setState(
                              () => _currentSpriteIndex = i,
                            ),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 70),
                                child: Image.network(
                                  _spriteUrls[index],
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, progress) {
                                    if(progress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 3,),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.catching_pokemon, color: Colors.black, size: 60,),
                                ),
                              );
                            },
                          ),
        
                          //Arrow
                          if(_currentSpriteIndex > 0)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.chevron_left),
                                iconSize: 36,
                                color: Colors.black54,
                                onPressed: () => _goToSprite(_currentSpriteIndex - 1),
                              ),
                            ),
        
                            //Arrow
                          if(_currentSpriteIndex < _spriteUrls.length - 1)
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.chevron_right),
                                iconSize: 36,
                                color: Colors.black54,
                                onPressed: () => _goToSprite(_currentSpriteIndex + 1),
                              ),
                            ),
        
                          //Indicator dots
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '${_currentSpriteIndex + 1} / ${_spriteUrls.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: IconButton(
                                onPressed: () => AudioHelper.instance.playSoundEffect(pokemonResponse.cries.latest, true),
                                icon: const Icon(Icons.audiotrack),
                                iconSize: 50,
                                color: Colors.black87,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ),
        
                  //Name
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.28,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                              child: AutoSizeText(
                                pokemonResponse.name[0].toUpperCase() + pokemonResponse.name.substring(1),
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ),
                                    
                            //Type
                            Container(
                              width: double.maxFinite,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: 
                                  pokemonResponse.types.map((type) {
                                    return Container(
                                      width: 110,
                                      margin: const EdgeInsets.fromLTRB(20, 15, 0, 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getTypeColor(type.type["name"]),
                                        border: Border.all(width: 4, color: getTypeBorder(type.type["name"])),
                                      ),
                                      child: Text(
                                        type.type["name"][0].toString().toUpperCase() + type.type["name"].toString().substring(1),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                              
                      //Stats
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.28,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsetsGeometry.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: getTypeColor(pokemonResponse.types[0].type["name"]),
                                border: Border.all(width: 4, color: getTypeBorder(pokemonResponse.types[0].type["name"])),
                                borderRadius: BorderRadiusGeometry.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsGeometry.all(10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: stats.length,
                                  itemBuilder: (context, index) {
                                    final stat = stats[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 50,
                                            child: Text(
                                              _getStatName(stat.stat["name"]),
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            )
                                          ),
                                          const SizedBox(width: 8,),
                                          SizedBox(
                                            width: 28,
                                            child: Text(
                                              stat.base_stat.toString(),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: stat.base_stat / 255,
                                              minHeight: 8,
                                              backgroundColor: Colors.grey,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ],
                                      )
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        
                  //Abilities
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: getTypeColor(pokemonResponse.types[0].type["name"]),
                              border: Border.all(width: 4, color: getTypeBorder(pokemonResponse.types[0].type["name"])),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: abilities.length,
                                itemBuilder: (context, index){
                                  final ability = abilities[index];
                                  return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 8, color: getTypeBorder(pokemonResponse.types[0].type["name"])),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          width: double.maxFinite,
                                          margin: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                ability.ability!["name"].toString()[0].toUpperCase() + ability.ability!["name"].toString().substring(1),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            
                                              AbilitiesDetailScreen(name: ability.ability!["name"].toString()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Species
                  FutureBuilder(
                    future: _speciesFuture,
                    builder: (context, speciesSnapshot) {
                      if (speciesSnapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (speciesSnapshot.hasError || !speciesSnapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Text('Could not load species data')),
                        );
                      }

                      final speciesResponse =
                          PokemonSpeciesResponse.fromRawJson(speciesSnapshot.data!.body);

                      return PokemonAttributesSection(
                        species: speciesResponse,
                        primaryType: pokemonResponse.types[0].type["name"] as String,
                      );
                    }
                  ),

                  const SizedBox(height: 40,)
                ],
              );
        
            }
          }
        ),
      ),
    );
  }
}