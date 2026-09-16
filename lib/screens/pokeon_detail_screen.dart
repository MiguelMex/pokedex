import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon_detail_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';

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
                      color: Colors.lightGreenAccent,
                      border: Border(bottom: BorderSide(width: 4, color: Colors.green))
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
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    border: Border.all(
                      color: Colors.green,
                      width: 4,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                    child: Text(
                      pokemonResponse.types[0].type["name"],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                        color: Colors.white,
                        border: Border.all(width: 4, color: Colors.blueGrey)
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
                                      stat.stat['name'].replaceAll('-', ' ').toUpperCase(),
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
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        stat.base_stat > 100
                                          ? Colors.green : stat.base_stat > 50
                                           ? Colors.orange : Colors.red
                                      ),
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