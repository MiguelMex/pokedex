import 'dart:convert';

class PokemonAbility{
  final int id;
  final String name;
  final Generation generation;
  final List<Name> names;
  final List<Effect> effect_entries;
  final List<Pokemon> pokemon;

  PokemonAbility({
    required this.id,
    required this.name,
    required this.generation,
    required this.names,
    required this.effect_entries,
    required this.pokemon
  });

  factory PokemonAbility.fromRawJson(String str) => PokemonAbility.fromJson(json.decode(str));

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    var generationResults = Generation.fromJson(json["generation"]);

    var namesResult = json["names"] as List? ?? [];
    List<Name> namesList = namesResult.map((a) => Name.fromJson(a)).toList();

    var effectResults = json["effect_entries"] as List? ?? [];
    List<Effect> effectList = effectResults.map((a) => Effect.fromJson(a)).toList();

    var pokemonResults = json["pokemon"] as List? ?? [];
    List<Pokemon> pokemonList = pokemonResults.map((a) => Pokemon.fromJson(a)).toList();

    return PokemonAbility(
      id: json["id"],
      name: json["name"],
      generation: generationResults,
      names: namesList,
      effect_entries: effectList,
      pokemon: pokemonList
    );
  }
}

class Generation{
  final String name;
  final String url;

  Generation({
    required this.name,
    required this.url
  });

  factory Generation.fromRawJson(String str) => Generation.fromJson(json.decode(str));

  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation(
      name: json["name"],
      url: json["url"]
    );
  }
}

class Name{
  final String name;
  final Language language;

  Name({
    required this.name,
    required this.language
  });

  factory Name.fromRawJson(String str) => Name.fromJson(json.decode(str));

  factory Name.fromJson(Map<String, dynamic> json) {
    var languageResult = Language.fromJson(json["language"]);
    return Name(
      name: json["name"],
      language: languageResult
    );
  }
}

class Language{
  final String name;
  final String url;

  Language({
    required this.name,
    required this.url
  });

  factory Language.fromRawJson(String str) => Language.fromJson(json.decode(str));

  factory Language.fromJson(Map<String, dynamic> json)  {
    return Language(name: 
      json["name"],
      url: json["url"]
    );
  }
}

class Effect{
  final String effect;
  final String short_effect;
  final Language language;

  Effect({
    required this.effect,
    required this.short_effect,
    required this.language
  });

  factory Effect.fromRawJson(String str) => Effect.fromJson(json.decode(str));


  factory Effect.fromJson(Map<String, dynamic> json) {
    var languageResult = Language.fromJson(json["language"]);
    return Effect(
      effect:json["effect"],
      short_effect: json["short_effect"],
      language: languageResult
    );
  }
}

class Pokemon{
  final bool is_hidden;
  final int slot;
  final PokemonItem pokemon;

  Pokemon({
    required this.is_hidden,
    required this.slot,
    required this.pokemon
  });

  factory Pokemon.fromRawJson(String str) => Pokemon.fromJson(json.decode(str));

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    var pokemonResults = PokemonItem.fromJson(json["pokemon"]);
    return Pokemon(
      is_hidden: json["is_hidden"],
      slot: json["slot"],
      pokemon: pokemonResults,
    );
  }
}

class PokemonItem{
  final String name;
  final String url;

  PokemonItem({
    required this.name,
    required this.url
  });

  factory PokemonItem.fromRawJson(String str) => PokemonItem.fromJson(json.decode(str));

  factory PokemonItem.fromJson(Map<String, dynamic> json){
    return PokemonItem(
      name: json["name"],
      url: json["url"]
    );
  }
}