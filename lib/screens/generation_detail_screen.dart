import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/models/generation_detail_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'package:pokedex/screens/pokemon_type_colors.dart';
import 'package:pokedex/screens/pokeon_detail_screen.dart';

class GenerationDetailScreen extends StatelessWidget {
  final int generationId;
  const GenerationDetailScreen({Key? key,required this.generationId}) : super (key: key);

  String _spriteUrl(int id) => 
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Generacion $generationId'),
      ),
      body: FutureBuilder(
        future: PokeApiProvider().getGenerationDetail(generationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'),);
          } else if(!snapshot.hasData){
            return const Center(child: Text('No data available'),);
          } else {
            final generationDetailResponse = GenerationDetailResponse.fromRawJson(snapshot.data!.body);
            final speciesList = generationDetailResponse.pokemonSpecies;
            return GridView.builder(
              padding: const EdgeInsets.all(6),
              itemCount: speciesList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final species = speciesList[index];
                return _PokemonCard(
                  id: species.id,
                  name: species.name,
                  imageUrl: _spriteUrl(species.id),
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailScreen(pokemonId: species.id, pokemonName: species.name),
                      )
                    );
                  }
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(5),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kBlackSoft.withAlpha(30),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.network(
                    alignment: AlignmentGeometry.center,
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2,),
                        )
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.catching_pokemon, color: colorScheme.secondary), 
                  ),
                ),
              ),

              const SizedBox(height: 4,),

              Column(
                children: [
                  Text(
                    'N.º ${id.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: kBlackSoft.withAlpha(100),
                    ),
                  ),
                  const SizedBox(height: 2,),
                  Text(
                    name[0].toUpperCase() + name.substring(1),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kBlackSoft,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}