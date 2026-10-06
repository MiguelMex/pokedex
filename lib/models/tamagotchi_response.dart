import 'dart:convert';

class TamagotchiResponse {
  final int id;
  final int idPokemonUser;
  final int hambre;
  final int energia;
  final int higiene;
  final int vidaActual;
  final int vidaTotal;
  final String estado;
  final bool vivo;
  final DateTime fechaAdopcion;

  TamagotchiResponse({
    required this.id,
    required this.idPokemonUser,
    required this.hambre,
    required this.energia,
    required this.higiene,
    required this.vidaActual,
    required this.vidaTotal,
    required this.estado,
    required this.vivo,
    required this.fechaAdopcion
  });

  factory TamagotchiResponse.fromRawJson(String str) => TamagotchiResponse.fromJson(json.decode(str));

  factory TamagotchiResponse.fromJson(Map<String, dynamic> json){
    return TamagotchiResponse(
      id: json["id"],
      idPokemonUser: json["idPokemonUser"],
      hambre: json["hambre"],
      energia: json["energia"],
      higiene: json["higiene"],
      vidaActual: json["vidaActual"],
      vidaTotal: json["vidaTotal"],
      estado: json["estado"],
      vivo: json["vivo"],
      fechaAdopcion: json["fechaAdopcion"]
    );
  }
}

