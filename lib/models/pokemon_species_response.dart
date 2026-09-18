// pokemon_species_response.dart

import 'dart:convert';

class PokemonSpeciesResponse {
  final int id;
  final String name;
  final int order;
  final int gender_rate;
  final int capture_rate;
  final int base_happiness;
  final bool is_baby;
  final bool is_legendary;
  final bool is_mythical;
  final int hatch_counter;
  final bool has_gender_differences;
  final bool forms_switchable;
  final Map<String, dynamic> growth_rate;
  final List<PokedexNumber> pokedex_numbers;
  final List<Map<String, dynamic>> egg_groups;
  final Map<String, dynamic> color;
  final Map<String, dynamic> shape;
  final Map<String, dynamic>? evolves_from_species;
  final Map<String, dynamic> evolution_chain;
  final Map<String, dynamic>? habitat;
  final Map<String, dynamic> generation;
  final List<Name> names;
  final List<PalParkEncounter> pal_park_encounters;
  final List<dynamic> form_descriptions;
  final List<FlavorTextEntry> flavor_text_entries;
  final List<Genera> genera;
  final List<Variety> varieties;

  PokemonSpeciesResponse({
    required this.id,
    required this.name,
    required this.order,
    required this.gender_rate,
    required this.capture_rate,
    required this.base_happiness,
    required this.is_baby,
    required this.is_legendary,
    required this.is_mythical,
    required this.hatch_counter,
    required this.has_gender_differences,
    required this.forms_switchable,
    required this.growth_rate,
    required this.pokedex_numbers,
    required this.egg_groups,
    required this.color,
    required this.shape,
    this.evolves_from_species,
    required this.evolution_chain,
    this.habitat,
    required this.generation,
    required this.names,
    required this.pal_park_encounters,
    required this.form_descriptions,
    required this.flavor_text_entries,
    required this.genera,
    required this.varieties,
  });

  factory PokemonSpeciesResponse.fromRawJson(String str) =>
      PokemonSpeciesResponse.fromJson(json.decode(str));

  factory PokemonSpeciesResponse.fromJson(Map<String, dynamic> json) {
    var pokedexNumbersList = json['pokedex_numbers'] as List? ?? [];
    List<PokedexNumber> pokedexNumbersMapped =
        pokedexNumbersList.map((a) => PokedexNumber.fromJson(a)).toList();

    var eggGroupsList = json['egg_groups'] as List? ?? [];
    List<Map<String, dynamic>> eggGroupsMapped =
        eggGroupsList.map((a) => a as Map<String, dynamic>).toList();

    var namesList = json['names'] as List? ?? [];
    List<Name> namesMapped = namesList.map((a) => Name.fromJson(a)).toList();

    var palParkList = json['pal_park_encounters'] as List? ?? [];
    List<PalParkEncounter> palParkMapped =
        palParkList.map((a) => PalParkEncounter.fromJson(a)).toList();

    var flavorList = json['flavor_text_entries'] as List? ?? [];
    List<FlavorTextEntry> flavorMapped =
        flavorList.map((a) => FlavorTextEntry.fromJson(a)).toList();

    var generaList = json['genera'] as List? ?? [];
    List<Genera> generaMapped =
        generaList.map((a) => Genera.fromJson(a)).toList();

    var varietiesList = json['varieties'] as List? ?? [];
    List<Variety> varietiesMapped =
        varietiesList.map((a) => Variety.fromJson(a)).toList();

    return PokemonSpeciesResponse(
      id: json['id'],
      name: json['name'],
      order: json['order'],
      gender_rate: json['gender_rate'],
      capture_rate: json['capture_rate'],
      base_happiness: json['base_happiness'],
      is_baby: json['is_baby'],
      is_legendary: json['is_legendary'],
      is_mythical: json['is_mythical'],
      hatch_counter: json['hatch_counter'],
      has_gender_differences: json['has_gender_differences'],
      forms_switchable: json['forms_switchable'],
      growth_rate: json['growth_rate'],
      pokedex_numbers: pokedexNumbersMapped,
      egg_groups: eggGroupsMapped,
      color: json['color'],
      shape: json['shape'],
      evolves_from_species: json['evolves_from_species'],
      evolution_chain: json['evolution_chain'],
      habitat: json['habitat'],
      generation: json['generation'],
      names: namesMapped,
      pal_park_encounters: palParkMapped,
      form_descriptions: json['form_descriptions'] as List? ?? [],
      flavor_text_entries: flavorMapped,
      genera: generaMapped,
      varieties: varietiesMapped,
    );
  }
}

class PokedexNumber {
  final int entry_number;
  final Map<String, dynamic> pokedex;

  PokedexNumber({
    required this.entry_number,
    required this.pokedex,
  });

  factory PokedexNumber.fromRawJson(String str) =>
      PokedexNumber.fromJson(json.decode(str));

  factory PokedexNumber.fromJson(Map<String, dynamic> json) {
    return PokedexNumber(
      entry_number: json['entry_number'],
      pokedex: json['pokedex'],
    );
  }
}

class Name {
  final String name;
  final Map<String, dynamic> language;

  Name({
    required this.name,
    required this.language,
  });

  factory Name.fromRawJson(String str) => Name.fromJson(json.decode(str));

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      name: json['name'],
      language: json['language'],
    );
  }
}

class PalParkEncounter {
  final int base_score;
  final int rate;
  final Map<String, dynamic> area;

  PalParkEncounter({
    required this.base_score,
    required this.rate,
    required this.area,
  });

  factory PalParkEncounter.fromRawJson(String str) =>
      PalParkEncounter.fromJson(json.decode(str));

  factory PalParkEncounter.fromJson(Map<String, dynamic> json) {
    return PalParkEncounter(
      base_score: json['base_score'],
      rate: json['rate'],
      area: json['area'],
    );
  }
}

class FlavorTextEntry {
  final String flavor_text;
  final Map<String, dynamic> language;
  final Map<String, dynamic> version;

  FlavorTextEntry({
    required this.flavor_text,
    required this.language,
    required this.version,
  });

  factory FlavorTextEntry.fromRawJson(String str) =>
      FlavorTextEntry.fromJson(json.decode(str));

  factory FlavorTextEntry.fromJson(Map<String, dynamic> json) {
    return FlavorTextEntry(
      flavor_text: json['flavor_text'],
      language: json['language'],
      version: json['version'],
    );
  }
}

class Genera {
  final String genus;
  final Map<String, dynamic> language;

  Genera({
    required this.genus,
    required this.language,
  });

  factory Genera.fromRawJson(String str) => Genera.fromJson(json.decode(str));

  factory Genera.fromJson(Map<String, dynamic> json) {
    return Genera(
      genus: json['genus'],
      language: json['language'],
    );
  }
}

class Variety {
  final bool is_default;
  final Map<String, dynamic> pokemon;

  Variety({
    required this.is_default,
    required this.pokemon,
  });

  factory Variety.fromRawJson(String str) => Variety.fromJson(json.decode(str));

  factory Variety.fromJson(Map<String, dynamic> json) {
    return Variety(
      is_default: json['is_default'],
      pokemon: json['pokemon'],
    );
  }
}