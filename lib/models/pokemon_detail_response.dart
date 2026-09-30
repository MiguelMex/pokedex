import 'dart:convert';

import 'package:http/http.dart' as http;

class PokemonDetailResponse{
  final int id;
  final String name;
  final int base_experience;
  final int height;
  final bool is_default;
  final int order;
  final int weight;
  final List<Ability> abilities;
  final List<PastAbility> past_abilities;
  final List<FormItem> forms;
  final List<GameIndex> game_indices;
  final List<MoveItem> moves;
  final Species species;
  final Sprites sprites;
  final Cries cries;
  final List<Stat> stats;
  final List<PastStat> past_stats;
  final List<Type> types;

  PokemonDetailResponse({
    required this.id,
    required this.name,
    required this.base_experience,
    required this.height,
    required this.is_default,
    required this.order,
    required this.weight,
    required this.abilities,
    required this.past_abilities,
    required this.forms,
    required this.game_indices,
    required this.moves,
    required this.species,
    required this.sprites,
    required this.cries,
    required this.stats,
    required this.past_stats,
    required this.types
  });

  factory PokemonDetailResponse.fromRawJson(String str) => PokemonDetailResponse.fromJson(json.decode(str));

  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json){

    var abilitiesResponse = json['abilities'] as List? ?? [];
    List<Ability> abilitiesMapped = abilitiesResponse.map((a) => Ability.fromJson(a)).toList();

    var pastAbilities = json['past_abilities'] as List? ?? [];
    List<PastAbility> pastAbilitiesMapped = pastAbilities.map((a) => PastAbility.fromJson(a)).toList();

    var formsResponse = json['forms'] as List? ?? [];
    List<FormItem> formsMapped = formsResponse.map((a) => FormItem.fromJson(a)).toList();

    var indexResponse = json['game_indices'] as List? ?? [];
    List<GameIndex> indexMapped = indexResponse.map((a) => GameIndex.fromJson(a)).toList();

    var moveItem = json['moves'] as List? ?? [];
    List<MoveItem> moveItemMapped = moveItem.map((a) => MoveItem.fromJson(a)).toList();

    var speciesResponse = Species.fromJson(json['species']);

    var spritesResponse = Sprites.fromJson(json['sprites']);

    var criesResponse = Cries.fromJson(json['cries']);

    var statsList = json['stats'] as List? ?? [];
    List<Stat> statMapped = statsList.map((a) => Stat.fromJson(a)).toList();

    var pastStats = json['past_stats'] as List? ?? [];
    List<PastStat> pastStatsMapped = pastStats.map((a) => PastStat.fromJson(a)).toList();

    var typesResponse = json['types'] as List? ?? [];
    List<Type> typesMapped = typesResponse.map((a) => Type.fromJson(a)).toList();

    return PokemonDetailResponse(
      id: json['id'],
      name: json['name'],
      base_experience: json['base_experience'],
      height: json['height'],
      is_default: json['is_default'],
      order: json['order'],
      weight: json['weight'],
      abilities: abilitiesMapped,
      past_abilities: pastAbilitiesMapped,
      forms: formsMapped,
      game_indices: indexMapped,
      moves: moveItemMapped,
      species: speciesResponse,
      sprites: spritesResponse,
      cries: criesResponse,
      stats: statMapped,
      past_stats: pastStatsMapped,
      types: typesMapped,
    );

  }
}

class Ability{
  final bool is_hidden;
  final int slot;
  final Map<String, dynamic>? ability;

  Ability({
    required this.is_hidden,
    required this.slot,
    this.ability
  });

  factory Ability.fromRawJson(String str) => Ability.fromJson(json.decode(str));

  factory Ability.fromJson(Map<String, dynamic> json){
    return Ability(
      is_hidden: json['is_hidden'],
      slot: json['slot'],
      ability: json['ability'],
    );
  }
}

class PastAbility{
  final Map<String, dynamic> generation;
  final List<Ability> abilities;

  PastAbility({
    required this.generation,
    required this.abilities
  });

  factory PastAbility.fromRawJson(String str) => PastAbility.fromJson(json.decode(str));

  factory PastAbility.fromJson(Map<String, dynamic> json){
    var generationList = json['generation'] as Map<String, dynamic>? ?? {};
    
    var abilities = json['abilities'] as List? ?? [];
    List<Ability> abilitiesMapped = abilities.map((a) => Ability.fromJson(a)).toList();

    return PastAbility(
      generation: generationList,
      abilities: abilitiesMapped,
    );
  }
}

class FormItem{
  final String name;
  final String url;

  FormItem({
    required this.name,
    required this.url
  });

  factory FormItem.fromRawJson(String str) => FormItem.fromJson(json.decode(str));

  factory FormItem.fromJson(Map<String, dynamic> json){
    return FormItem(
      name: json['name'],
      url: json['url'],
    );
  }
}

class GameIndex{
  final int game_index;
  final Map<String, dynamic> version;

  GameIndex({
    required this.game_index,
    required this.version
  });

  factory GameIndex.fromRawJson(String str) => GameIndex.fromJson(json.decode(str));

  factory GameIndex.fromJson(Map<String, dynamic> json){
    return GameIndex(
      game_index: json['game_index'],
      version: json['version'],
    );
  }
}

class MoveItem{
  final Move move;
  final List<VersionGroupDetails> version_group_details;

  MoveItem({
    required this.move,
    required this.version_group_details
  });

  factory MoveItem.fromRawJson(String str) => MoveItem.fromJson(json.decode(str));

  factory MoveItem.fromJson(Map<String, dynamic> json){
    var moveResult = json['move'] ?? '';
    Move moveMapped = Move.fromJson(moveResult);

    var versionResult =  json['version_group_details'] as List? ?? [];
    List<VersionGroupDetails> versionMapped = versionResult.map((a) => VersionGroupDetails.fromJson(a)).toList();

    return MoveItem(
      move: moveMapped,
      version_group_details: versionMapped,
    );
  }
}

class Move{
  final String name;
  final String url;

  Move({
    required this.name,
    required this.url
  });

  factory Move.fromRawJson(String str) => Move.fromJson(json.decode(str));

  factory Move.fromJson(Map<String, dynamic> json){
    return Move(
      name: json['name'],
      url: json['url'],
    );
  }
}

class VersionGroupDetails{
  final int level_learned_at;
  final Map<String, dynamic> version_group;
  final Map<String, dynamic> move_learn_method;
  final int? order;

  VersionGroupDetails({
    required this.level_learned_at,
    required this.version_group,
    required this.move_learn_method,
    this.order
  });

  factory VersionGroupDetails.fromRawJson(String str) => VersionGroupDetails.fromJson(json.decode(str));

  factory VersionGroupDetails.fromJson(Map<String, dynamic> json){
    return VersionGroupDetails(
      level_learned_at: json['level_learned_at'],
      version_group: json['version_group'],
      move_learn_method: json['move_learn_method'],
      order: json['order'],
    );
  }
}

class Species{
  final String name;
  final String url;

  Species({
    required this.name,
    required this.url
  });

  factory Species.fromRawJson(String str) => Species.fromJson(json.decode(str));

  factory Species.fromJson(Map<String, dynamic> json){
    return Species(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Sprites{
  final Map<String, dynamic> other;
  final Map<String, dynamic> versions;

  Sprites({
    required this.other,
    required this.versions
  });

  factory Sprites.fromRawJson(String str) => Sprites.fromJson(json.decode(str));

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      other: json['other'],
      versions: json['versions'],
    );
  }
}

class Cries{
  final String? latest;
  final String? legacy;

  Cries({
    this.latest,
    this.legacy
  });

  factory Cries.fromRawJson(String str) => Cries.fromJson(json.decode(str));

  factory Cries.fromJson(Map<String, dynamic> json){
    return Cries(
      latest: json['latest'] as String?,
      legacy: json['legacy'] as String?,
    );
  }
}

class Stat{
  final int base_stat;
  final int effort;
  final Map<String, dynamic> stat;

  Stat({
    required this.base_stat,
    required this.effort,
    required this.stat
  });

  factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

  factory Stat.fromJson(Map<String, dynamic> json){
    return Stat(
      base_stat: json['base_stat'],
      effort: json['effort'],
      stat: json['stat']
    );
  }
}

class PastStat{
  final Map<String, dynamic>? generation;
  final List<Stat> stats;

  PastStat({
    this.generation,
    required this.stats
  });

  factory PastStat.fromRawJson(String str) => PastStat.fromJson(json.decode(str));

  factory PastStat.fromJson(Map<String, dynamic> json){
    var list = json['stats'] as List? ?? [];
    List<Stat> statList = list.map((a) => Stat.fromJson(a)).toList();
    return PastStat(
      generation: json['generarion'],
      stats: statList,
    );
  }
}

class Type{
  final int slot;
  final Map<String, dynamic> type;

  Type({
    required this.slot,
    required this.type
  });

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      slot: json['slot'],
      type: json['type']
    );
  }
}