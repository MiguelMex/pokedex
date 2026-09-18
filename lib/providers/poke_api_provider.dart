import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokeApiProvider extends ChangeNotifier {
  final String _baseUrl = 'pokeapi.co';
  final String _apiPatch = '/api/v2';

  Future<http.Response> getGenerations() async {
    final url = Uri.https(_baseUrl, "$_apiPatch/generation");
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> getGenerationDetail(int id) async {
    final url = Uri.https(_baseUrl, "$_apiPatch/generation/$id");
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> getPokemon(int id) async {
    final url = Uri.http(_baseUrl, "$_apiPatch/pokemon/$id");
    final response = await http.get(url);
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
    return response;
  }
}