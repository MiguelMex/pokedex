import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_ability_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'package:http/http.dart' as http;

class AbilitiesDetailScreen extends StatelessWidget {
  final int? id;
  final String? name;

  const AbilitiesDetailScreen({super.key, this.id, this.name});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PokeApiProvider().getAbility(name: name),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'),);
          } else if (!snapshot.hasData){
            return const Center(child: Text('No data :('));
          } else {
            final ability = PokemonAbility.fromRawJson(snapshot.data!.body);

            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Text(
                ability.effect_entries[2].effect,
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
      }
    );
  }
}