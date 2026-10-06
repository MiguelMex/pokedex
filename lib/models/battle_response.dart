import 'dart:convert';

class BattleResponse {
  final int id;
  final int idPokemon;
  final String idUsuario;
  final String name;
  final PokemonState? pokemonEstado;

  BattleResponse({
    required this.id,
    required this.idPokemon,
    required this.idUsuario,
    required this.name,
    this.pokemonEstado
  });

  factory BattleResponse.fromRawJson(String str) => BattleResponse.fromJson(json.decode(str));

  factory BattleResponse.fromJson(Map<String, dynamic> json){
    var pokemonStateData = PokemonState.fromJson(json["pokemonEstado"]);
    return BattleResponse(
      id: json["id"],
      idPokemon: json["idPokemon"],
      idUsuario: json["idUsuario"],
      name: json["name"],
      pokemonEstado: pokemonStateData,
    );
  }

}

class PokemonState{
  final int vidaTotal;
  final int vidaActual;
  final int estado;
  final int ataqueBase;
  final int defensaBase;
  final int velocidadBase;
  final int tipoPrimario;
  final int tipoSecundario;
  final int urlFrontal;
  final int urlTrasera;

  PokemonState({
    required this.vidaTotal,
    required this.vidaActual,
    required this.estado,
    required this.ataqueBase,
    required this.defensaBase,
    required this.velocidadBase,
    required this.tipoPrimario,
    required this.tipoSecundario,
    required this.urlFrontal,
    required this.urlTrasera
  });

  factory PokemonState.fromRawJson(String str) => PokemonState.fromJson(json.decode(str));

  factory PokemonState.fromJson(Map<String, dynamic> json){
    return PokemonState(
      vidaTotal: json["vidaTotal"],
      vidaActual: json["vidaActual"],
      estado: json["estado"],
      ataqueBase: json["ataqueBase"],
      defensaBase: json["defensaBase"],
      velocidadBase: json["velocidadBase"],
      tipoPrimario: json["tipoPrimario"],
      tipoSecundario: json["tipoSecundario"],
      urlFrontal: json["urlFrontal"],
      urlTrasera: json["urlTrasera"]
    );
  }
}

class State{
  final int vidaActual;
  final int estado;

  State({
    required this.vidaActual,
    required this.estado
  });

  factory State.fromRawJson(String str) => State.fromJson(json.decode(str));

  factory State.fromJson(Map<String, dynamic> json){
    return State(
      vidaActual: json["vidaActual"],
      estado: json["estado"]
    );
  }
}

class Battle{
  final int pokemonUserR;
  final int idPokemonRival;
  final DateTime fecha;
  final int pokemonUserGanador;

  Battle({
    required this.pokemonUserR,
    required this.idPokemonRival,
    required this.fecha,
    required this.pokemonUserGanador
  });

  factory Battle.fromRawJson(String str) => Battle.fromJson(json.decode(str));

  factory Battle.fromJson(Map<String, dynamic> json){
    return Battle(
      pokemonUserR: json["pokemonUserR"],
      idPokemonRival: json["idPokemonRival"],
      fecha: json["fecha"],
      pokemonUserGanador: json["pokemonUserGanador"]
    );
  }

}

class UserItems{
  final int id;
  final int idItem;
  final int idUser;
  final int cantidad;
  final Item? item;

  UserItems({
    required this.id,
    required this.idItem,
    required this.idUser,
    required this.cantidad,
    this.item
  });

  factory UserItems.fromRawJson(String str) => UserItems.fromJson(json.decode(str));

  factory UserItems.fromJson(Map<String, dynamic> json){
    var itemData = Item.fromJson(json["item"]);
    return UserItems(
      id: json["id"],
      idItem: json["idItem"],
      idUser: json["idUser"],
      cantidad: json["cantidad"],
      item: itemData
    );
  }
}

class Item{
  final int id;
  final String name;
  final double probabilidad;
  final String urlImagen;
  final String descripcion;
  final String efecto;
  final int valor;

  Item({
    required this.id,
    required this.name,
    required this.probabilidad,
    required this.urlImagen,
    required this.descripcion,
    required this.efecto,
    required this.valor
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      id: json["id"],
      name: json["name"],
      probabilidad: json["probabilidad"],
      urlImagen: json["urlImagen"],
      descripcion: json["descripcion"],
      efecto: json["efecto"],
      valor: json["valor"]
    );
  }

}

// { "id": 1, "nombre": "Sano" },
// { "id": 2, "nombre": "Dormido" },
// { "id": 3, "nombre": "Quemado" },
// { "id": 4, "nombre": "Envenenado" },
// { "id": 5, "nombre": "Paralizado" },
// { "id": 6, "nombre": "Confundido" },
// { "id": 7, "nombre": "Congelado" }