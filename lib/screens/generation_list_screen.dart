import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/helpers/audio_helper.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/models/generation_list_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'package:pokedex/screens/generation_detail_screen.dart';
import 'package:pokedex/screens/music_config_screen.dart';
import 'package:provider/provider.dart';

class GenerationListScreen extends StatelessWidget {
  const GenerationListScreen({super.key});

  void _playMusic() async{
    
  }

  String _getGenerationBackground(String gen){
    switch(gen){
      case 'generation-i': return 'assets/images/kanto.jpg';
      case 'generation-ii': return 'assets/images/johto.png';
      case 'generation-iii': return 'assets/images/hoenn.webp';
      case 'generation-iv': return 'assets/images/sinnoh.webp';
      case 'generation-v': return 'assets/images/teselia.png';
      case 'generation-vi': return 'assets/images/kalos.png';
      case 'generation-vii': return 'assets/images/alola.jpg';
      case 'generation-viii': return 'assets/images/galar.jpg';
      case 'generation-ix': return 'assets/images/paldea.jpg';

      default: return 'assets/images/kanto.jpg';
    }
  }

  String _getGeneration(String gen){
    switch(gen){
      case 'generation-i': return 'Kanto';
      case 'generation-ii': return 'Johto';
      case 'generation-iii': return 'Hoenn';
      case 'generation-iv': return 'Sinnoh';
      case 'generation-v': return 'Teselia';
      case 'generation-vi': return 'Kalos';
      case 'generation-vii': return 'Alola';
      case 'generation-viii': return 'Galar';
      case 'generation-ix': return 'Paldea';

      default: return 'No gen';
    }
  }

  @override
  Widget build(BuildContext context) {
    _playMusic();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MusicConfigScreen())
              );
            },
            icon: Icon(
              Icons.catching_pokemon_sharp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12,)
        ],
        title: Text(
          'Generaciones',
          style: TextStyle(
            color: kBlackSoft,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Material(
        child: FutureBuilder<http.Response>(
          future: Provider.of<PokeApiProvider>(context, listen: false)
            .getGenerations(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError){
              return Center( child: Text('Error: ${snapshot.error}'),);
            } else if(!snapshot.hasData || snapshot.data!.statusCode != 200){
              return const Center(child: Text('Failed to load generations'),);
            } else {
              final generationListResponse = GenerationListResponse.fromJson(json.decode(snapshot.data!.body));
              return ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: generationListResponse.results.length,
                separatorBuilder: (context, index) => 
                  const SizedBox(
                    height: 20,
                  ),
                itemBuilder: (context, index) {
                  final generation = generationListResponse.results[index];
                  return Card( 
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    shadowColor: kBlack,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
        
                    child: Container( //Color past the inner border
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: kBlack.withAlpha(100),
                        borderRadius: BorderRadius.circular(20),
                      ),                    
        
                      child: Container( //The inner border
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: kBlueSoft, 
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
        
                        child: Card(
                          margin: EdgeInsetsGeometry.all(0),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: InkWell(
                            onTap: () async {
                              await AudioHelper.instance.playSoundEffect('audio/shiny-pokemon.mp3', false);
                              if(!context.mounted) return;
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => 
                                    GenerationDetailScreen(generationId: index +1)
                                )
                              );
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  _getGenerationBackground(generation.name),
                                  fit: BoxFit.fill,
                                ),
        
                                ColoredBox(color: kBlack.withAlpha(60)),
        
                                Center(
                                  child: Text(
                                    _getGeneration(generation.name),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      shadows: [
                                        Shadow(
                                          color: kBlackSoft,
                                          blurRadius: 20,
                                        )
                                      ]
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}