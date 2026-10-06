import 'dart:convert';

class CaptureResponse {
  final int id;  
  final int idEncuentro;
  final int idPokemon;
  final String nombre;
  final DateTime fechaCaptura;

  CaptureResponse({
    required this.id,
    required this.idEncuentro,
    required this.idPokemon,
    required this.nombre,
    required this.fechaCaptura
  });

  factory CaptureResponse.fromRawJson(String str) => CaptureResponse.fromJson(json.decode(str));

  factory CaptureResponse.fromJson(Map<String, dynamic> json){
    return CaptureResponse(
      id: json["id"],
      idEncuentro: json["idEncuentro"],
      idPokemon: json["idPokemon"],
      nombre: json["nombre"],
      fechaCaptura: json["fechaCaptura"]
    );
  }

}

class CatchAttempt{
  final bool capturado;
  final String mensaje;
  final int? idPokemonUser;
  final int? idPokemon;

  CatchAttempt({
    required this.capturado,
    required this.mensaje,
    this.idPokemonUser,
    this.idPokemon,
  });

  factory CatchAttempt.fromRawJson(String str) => CatchAttempt.fromJson(json.decode(str));

  factory CatchAttempt.fromJson(Map<String, dynamic> json){
    return CatchAttempt(
      capturado: json["capturado"],
      mensaje: json["mensaje"],
      idPokemon: json["idPokemon"],
      idPokemonUser: json["idPokemonUser"],
    );
  }
}

class Coordinates{
  final int id;
  final int idPokemon;
  final double latitud;  
  final double longitud;
  final DateTime fechaExpiracion;

  Coordinates({
    required this.id,
    required this.idPokemon,
    required this.latitud,
    required this.longitud,
    required this.fechaExpiracion
  });

  factory Coordinates.fromRawJson(String str) => Coordinates.fromJson(json.decode(str));

  factory Coordinates.fromJson(Map<String, dynamic> json){
    return Coordinates(
      id: json["id"],
      idPokemon: json["idPokemon"],
      latitud: json["latitud"],
      longitud: json["longitud"],
      fechaExpiracion: json["fechaExpiracion"]
    );
  }

}