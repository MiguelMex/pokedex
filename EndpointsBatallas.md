# Endpoints de batallas

## Equipo Pokémon

### GET `/api/PokemonUser/usuario/{userId}`

Obtiene los Pokémon capturados por un usuario con su estado incluido.

No requiere body.

### Respuesta `200 OK`

```json
[
  {
	"id": 12,
	"idPokemon": 25,
	"idUsuario": "usuario-id",
	"nombre": "pikachu",
	"pokemonEstado": {
	  "vidaTotal": 100,
	  "vidaActual": 90,
	  "estado": 1,
	  "ataqueBase": 55,
	  "defensaBase": 40,
	  "velocidadBase": 90,
	  "tipoPrimario": "electric",
	  "tipoSecundario": null,
	  "urlFrontal": "https://...",
	  "urlTrasera": "https://..."
	}
  }
]
```

## Estado del Pokémon

### PUT `/api/PokemonEstado/{idPokemonUser}`

Actualiza la vida y el estado después de una batalla.

### Body

```json
{
  "vidaActual": 90,
  "estado": 1
}
```

Estados válidos:

| Id | Estado |
|---:|---|
| 1 | Sano |
| 2 | Dormido |
| 3 | Quemado |
| 4 | Envenenado |
| 5 | Paralizado |
| 6 | Confundido |
| 7 | Congelado |

### Respuesta `204 No Content`

## Batallas

### POST `/api/Batallas`

Registra una batalla contra un Pokémon rival.

### Body

```json
{
  "pokemonUserR": 12,
  "idPokemonRival": 25,
  "fecha": "2026-09-29T18:00:00Z",
  "pokemonUserGanador": 12
}
```

`pokemonUserR` es el Pokémon capturado que participa como retador. `idPokemonRival` es el ID del Pokémon rival del catálogo.

### Respuesta `201 Created`

```json
{
  "id": 5,
  "pokemonUserR": 12,
  "idPokemonRival": 25,
  "fecha": "2026-09-29T18:00:00Z",
  "pokemonUserGanador": 12
}
```

### GET `/api/Batallas/usuario/{userId}`

Obtiene el historial de batallas del usuario.

No requiere body.

### Respuesta `200 OK`

```json
[
  {
	"id": 5,
	"pokemonUserR": 12,
	"idPokemonRival": 25,
	"fecha": "2026-09-29T18:00:00Z",
	"pokemonUserGanador": 12
  }
]
```

## Objetos del usuario

### GET `/api/ItemUser/usuario/{userId}`

Obtiene la mochila del usuario con la información de cada objeto.

### Respuesta `200 OK`

```json
[
  {
	"id": 3,
	"idItem": 1,
	"idUser": "usuario-id",
	"cantidad": 2,
	"item": {
	  "id": 1,
	  "nombre": "Poción",
	  "probabilidad": 0.5,
	  "urlImagen": "https://...",
	  "descripcion": "Recupera vida",
	  "efecto": "curar",
	  "valor": 20
	}
  }
]
```

### PUT `/api/ItemUser/{id}`

Actualiza la cantidad restante después de usar un objeto.

### Body

```json
{
  "cantidad": 1
}
```

### Respuesta `204 No Content`

## Catálogo de objetos

### GET `/api/Item`

Obtiene todos los objetos disponibles.

No requiere body.

### Respuesta `200 OK`

```json
[
  {
	"id": 1,
	"nombre": "Poción",
	"probabilidad": 0.5,
	"urlImagen": "https://...",
	"descripcion": "Recupera vida",
	"efecto": "curar",
	"valor": 20
  }
]
```

## Añadir recompensa al inventario

### POST `/api/ItemUser`

Añade un objeto ganado. Si el usuario ya lo tiene, suma la cantidad.

### Body

```json
{
  "idUser": "usuario-id",
  "idItem": 1,
  "cantidad": 2
}
```

## Catálogo de estados

### GET `/api/Estados`

Obtiene los siete estados disponibles.

### Respuesta `200 OK`

```json
[
  { "id": 1, "nombre": "Sano" },
  { "id": 2, "nombre": "Dormido" },
  { "id": 3, "nombre": "Quemado" },
  { "id": 4, "nombre": "Envenenado" },
  { "id": 5, "nombre": "Paralizado" },
  { "id": 6, "nombre": "Confundido" },
  { "id": 7, "nombre": "Congelado" }
]
