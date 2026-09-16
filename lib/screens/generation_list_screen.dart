import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/generation_list_response.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'package:pokedex/screens/generation_detail_screen.dart';
import 'package:provider/provider.dart';

class GenerationListScreen extends StatelessWidget {
  const GenerationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Generaciones')),
      ),
      body: FutureBuilder<http.Response>(
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
                  shadowColor: Colors.deepPurple,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Container( //Color past the inner border
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(0),

                    child: Container( //The inner border
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.deepPurpleAccent, 
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),

                      child: ListTile( //The actual content
                        title: Text(
                          generation.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Color.fromARGB(255, 44, 6, 114),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => 
                                GenerationDetailScreen(generationId: index +1)
                            )
                          );
                        },
                      ),
                    ),
                  )
                );
              },
            );
          }
        },
      ),
    );
  }
}