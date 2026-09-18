import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon_detail_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'abilities_detail_screen.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;
  final String pokemonName;
  const PokemonDetailScreen({super.key, required this.pokemonId, required this.pokemonName});

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
  
  //TODO: Adjust view so it doesn't shrink with more content

  @override
  void dispose(){
    _spriteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pokemonFuture = PokeApiProvider().getPokemon(widget.pokemonId);
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

  void scrollSprite(){
    setState(() {
      
    });
  }

  Color _GetTypeColor(String type){
    switch (type){
      case 'fire':     return Colors.orange;
      case 'water':    return Colors.blue;
      case 'grass':    return Colors.green;
      case 'electric': return Colors.yellow;
      case 'poison':   return Colors.purple;
      case 'flying':   return Colors.lightBlue;
      case 'bug':      return Colors.lightGreen;
      case 'normal':   return Colors.grey;
      case 'fighting': return Colors.redAccent;
      case 'psychic': return Colors.purpleAccent;
      case 'dragon': return Colors.lightBlueAccent;
      case 'ghost': return Colors.deepPurple;
      case 'dark': return Colors.black;
      case 'ground': return Colors.brown;
      case 'fairy': return Colors.pinkAccent;
      case 'rock': return Color.fromARGB(255, 85, 59, 30);
      case 'ice': return Colors.lightBlue;
      case 'steel': return Colors.blueGrey;

      default: return Colors.white;
    }
  }

  Color _GetTypeBorder(String type){
    switch (type){
      case 'fire':     return const Color.fromARGB(255, 163, 98, 0);
      case 'water':    return const Color.fromARGB(255, 20, 88, 143);
      case 'grass':    return const Color.fromARGB(255, 42, 97, 44);
      case 'electric': return const Color.fromARGB(255, 170, 157, 40);
      case 'poison':   return const Color.fromARGB(255, 102, 26, 116);
      case 'flying':   return const Color.fromARGB(255, 3, 114, 165);
      case 'bug':      return const Color.fromARGB(255, 87, 122, 46);
      case 'normal':   return const Color.fromARGB(255, 107, 107, 107);
      case 'fighting': return const Color.fromARGB(255, 151, 51, 51);
      case 'psychic': return const Color.fromARGB(255, 118, 35, 133);
      case 'dragon': return const Color.fromARGB(255, 39, 117, 153);
      case 'ghost': return const Color.fromARGB(255, 49, 28, 87);
      case 'dark': return const Color.fromARGB(255, 31, 31, 31);
      case 'ground': return const Color.fromARGB(255, 73, 52, 44);
      case 'fairy': return const Color.fromARGB(255, 175, 44, 88);
      case 'rock': return Color.fromARGB(255, 48, 33, 17);
      case 'ice': return const Color.fromARGB(255, 3, 109, 158);
      case 'steel': return const Color.fromARGB(255, 54, 70, 78);

      default: return const Color.fromARGB(255, 153, 151, 151);
    }
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
      body: FutureBuilder(
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
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: _GetTypeColor(pokemonResponse.types[0].type["name"]),
                      border: Border(bottom: BorderSide(width: 4, color: _GetTypeBorder(pokemonResponse.types[0].type["name"])))
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
                              padding: const EdgeInsets.all(8),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                '${_currentSpriteIndex + 1} / ${_spriteUrls.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // const SizedBox(width: 8,),
                              // ...List.generate(
                              //   _spriteUrls.length,
                              //   (i) => AnimatedContainer(
                              //     duration: const Duration(milliseconds: 200),
                              //     margin: const EdgeInsets.symmetric(
                              //       horizontal: 2,
                              //     ),
                              //     width: i == _currentSpriteIndex ? 10 : 6,
                              //     height: i == _currentSpriteIndex ? 10 : 6,
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       color: i == _currentSpriteIndex ? Colors.green : Colors.green.withAlpha(100),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ),

                //Name
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                  child: Text(
                    pokemonResponse.name[0].toUpperCase() + pokemonResponse.name.substring(1),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                //Type
                Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: 
                        pokemonResponse.types.map((type) {
                          return Container(
                            margin: const EdgeInsets.only(left: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _GetTypeColor(type.type["name"]),
                              border: Border.all(width: 4, color: _GetTypeBorder(type.type["name"])),
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
                    )
                  ),
                ),

                //Stats
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsGeometry.fromLTRB(20, 50, 20, 50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _GetTypeColor(pokemonResponse.types[0].type["name"]),
                        border: Border.all(width: 4, color: _GetTypeBorder(pokemonResponse.types[0].type["name"])),
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsGeometry.all(15),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: stats.length,
                          itemBuilder: (context, index) {
                            final stat = stats[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      _getStatName(stat.stat["name"]),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    )
                                  ),
                                  const SizedBox(width: 8,),
                                  SizedBox(
                                    width: 40,
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

                //Abilities
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _GetTypeColor(pokemonResponse.types[0].type["name"]),
                        border: Border.all(width: 4, color: _GetTypeBorder(pokemonResponse.types[0].type["name"])),
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
                                      border: Border.all(width: 8, color: _GetTypeBorder(pokemonResponse.types[0].type["name"]))
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
                                            fontSize: 16,
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

                //Descriptions
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.transparent,
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsetsGeometry.fromLTRB(50, 20, 50, 20),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: Colors.grey,
                //       ),
                //       padding: const EdgeInsets.all(12),
                //       child: ListView.builder(
                //         itemBuilder:
                //       ),
                //     ),
                //   ),
                // )

              ],
            );

          }
        }
      ),
    );
  }
}