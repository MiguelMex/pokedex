import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon_detail_response.dart';

class PokeApiProvider extends ChangeNotifier {
  final String _baseUrl = 'pokeapi.co';
  final String _apiPatch = '/api/v2';

  Future<http.Response> getGenerations() async {
    final url = Uri.https(_baseUrl, "$_apiPatch/generation");
    final response = await http.get(url);
    if(response.statusCode != 200){
      throw HttpException('Generations failed (${response.statusCode})');
    }
    return response;
  }

  Future<http.Response> getGenerationDetail(int id) async {
    final url = Uri.https(_baseUrl, "$_apiPatch/generation/$id");
    final response = await http.get(url);
    if(response.statusCode != 200){
      throw HttpException('Generation $id failed (${response.statusCode})');
    }
    return response;
  }

  Future<http.Response> getPokemon(int id) async {
    final url = Uri.https(_baseUrl, "$_apiPatch/pokemon/$id");
    final response = await http.get(url);
    if(response.statusCode != 200){
      throw HttpException('Pokemon $id failed (${response.statusCode})');
    }
    return response;
  }

  Future<http.Response> getPokemonByName(String name) async {
    final url = Uri.https(_baseUrl, "$_apiPatch/pokemon/$name");
    final response = await http.get(url);
    if(response.statusCode != 200){
      throw HttpException('Pokemon $name failed (${response.statusCode})');
    }
    return response;
  }

  //Not used
  Future<http.Response> getPokemonDislplay(String name) async {
    //https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png
    //https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/132.gif

    //Get the pokemon id
    final pokemon = await getPokemonByName(name);
    final id = PokemonDetailResponse.fromRawJson(pokemon.toString()).id;
    final url = Uri.https('raw.githubusercontent.com','PokeAPI/sprites/master/sprites/pokemon/$id.png');
    final response = await http.get(url);
    if(response.statusCode != 200){
      throw HttpException('Pokemon $name failed (${response.statusCode})');
    }
    return response;
  }

  Future<http.Response> getPokemonSpecies(String identifier) async {
    final url = identifier.startsWith('http')
      ? Uri.parse(identifier)
      : Uri.https(_baseUrl, "$_apiPatch/pokemon-species/$identifier");
    final response = await http.get(url);

    if(response.statusCode != 200){
      throw HttpException(
        'Species $identifier not found (${response.statusCode})',
      );
    }
    if(response.statusCode != 200){
      throw HttpException('Species $identifier failed (${response.statusCode})');
    }
    return response;
  }

  Future<http.Response> getAbility({String? name, int? id}) async {
    if(name == null && id ==null){
      throw ArgumentError('No value given');
    }

    if (name != null && id != null){
      throw ArgumentError('More than one value given');
    }

    final identifier = id?.toString() ?? name!;
    final url = Uri.https(_baseUrl, "$_apiPatch/ability/$identifier");

    final response = await http.get(url);
    if(response.statusCode != 200){
      throw HttpException('Ability $identifier failed (${response.statusCode})');
    }
    return response;
  }
}