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

# Endpoints de Tamagotchi

Todos los endpoints requieren autenticación mediante JWT:

```http
Authorization: Bearer {token}
```

## GET `/api/tamagotchi`

Obtiene todos los Tamagotchis del usuario autenticado.

No requiere body.

### Respuesta `200 OK`

```json
[
  {
	"id": 5,
	"idPokemonUser": 12,
	"idPokemon": 25,
	"hambre": 62,
	"energia": 80,
	"higiene": 45,
	"vidaActual": 90,
	"vidaTotal": 100,
	"estado": "Sano",
	"vivo": true,
	"fechaAdopcion": "2026-09-24T18:00:00Z"
  }
]
```

Las necesidades se recalculan según el tiempo transcurrido desde la última actualización.

## GET `/api/tamagotchi/{id}`

Obtiene un Tamagotchi concreto. El `id` corresponde al registro de `PokemonCrianza`.

Ejemplo:

```http
GET /api/tamagotchi/5
```

No requiere body.

### Respuesta `200 OK`

```json
{
  "id": 5,
  "idPokemonUser": 12,
  "idPokemon": 25,
  "hambre": 62,
  "energia": 80,
  "higiene": 45,
  "vidaActual": 90,
  "vidaTotal": 100,
  "estado": "Sano",
  "vivo": true,
  "fechaAdopcion": "2026-09-24T18:00:00Z"
}
```

## POST `/api/tamagotchi`

Adopta como Tamagotchi un Pokémon que ya haya sido capturado por el usuario.

### Body

```json
{
  "idPokemonUser": 12
}
```

El Pokémon debe existir, pertenecer al usuario, tener un `PokemonEstado` y no estar asociado ya a otro Tamagotchi.

### Respuesta `201 Created`

```json
{
  "id": 5,
  "idPokemonUser": 12,
  "idPokemon": 25,
  "hambre": 100,
  "energia": 100,
  "higiene": 100,
  "vidaActual": 100,
  "vidaTotal": 100,
  "estado": "Sano",
  "vivo": true,
  "fechaAdopcion": "2026-09-30T12:00:00Z"
}
```

## POST `/api/tamagotchi/{id}/actividad`

Ejecuta una actividad y devuelve el estado actualizado.

### Comer

```json
{
  "tipo": "comer"
}
```

Aumenta `hambre` en 25 puntos.

### Dormir

```json
{
  "tipo": "dormir"
}
```

Aumenta `energia` en 30 puntos y establece el estado `Dormido`.

### Bañar

```json
{
  "tipo": "bañar"
}
```

También se acepta `banar`. Aumenta `higiene` en 30 puntos.

### Curar

```json
{
  "tipo": "curar"
}
```

Aumenta `vidaActual` en 20 puntos sin superar `vidaTotal`.

### Respuesta `200 OK`

```json
{
  "id": 5,
  "idPokemonUser": 12,
  "idPokemon": 25,
  "hambre": 87,
  "energia": 80,
  "higiene": 45,
  "vidaActual": 90,
  "vidaTotal": 100,
  "estado": "Sano",
  "vivo": true,
  "fechaAdopcion": "2026-09-24T18:00:00Z"
}
```

## DELETE `/api/tamagotchi/{id}`

Libera el Tamagotchi sin eliminar el Pokémon capturado.

Ejemplo:

```http
DELETE /api/tamagotchi/5
```

### Respuesta `204 No Content`

No devuelve body.


# Endpoints de capturas

## Catálogo Pokémon disponible

Estos endpoints funcionan como proxy hacia PokeAPI y ya están implementados en el backend. Solo consultan información del catálogo; no crean encuentros ni capturas.

### GET `/api/pokemon/{id}`

Obtiene un Pokémon concreto.

```http
GET /api/pokemon/25
```

### GET `/api/pokemon?offset={offset}&limit={limit}`

Obtiene una lista paginada de Pokémon.

```http
GET /api/pokemon?offset=0&limit=20
```

### GET `/api/pokemon-species?limit={limit}`

Obtiene la lista de especies.

```http
GET /api/pokemon-species?limit=1
```

### GET `/api/pokemon-species/{id}`

Obtiene una especie concreta.

```http
GET /api/pokemon-species/25
```

### GET `/api/generation?limit={limit}`

Obtiene la lista de generaciones.

```http
GET /api/generation?limit=50
```

### GET `/api/generation/{id}`

Obtiene una generación concreta.

```http
GET /api/generation/1
```

## Endpoints propios de captura

Estos endpoints están documentados como parte del diseño del juego, pero actualmente **no están implementados** en el backend.

## Encuentros cercanos

### GET `/api/encuentros/cercanos?latitud={latitud}&longitud={longitud}`

Obtendría los Pokémon disponibles cerca de la ubicación del jugador.

Ejemplo:

```http
GET /api/encuentros/cercanos?latitud=40.4168&longitud=-3.7038
```

No requiere body.

Respuesta propuesta:

```json
[
  {
	"id": 101,
	"idPokemon": 25,
	"nombre": "pikachu",
	"latitud": 40.4168,
	"longitud": -3.7038,
	"fechaExpiracion": "2026-09-30T12:30:00Z"
  }
]
```

## Crear una captura

### POST `/api/capturas`

Registraría un Pokémon capturado por el usuario.

Body propuesto:

```json
{
  "idEncuentro": 101,
  "idUsuario": "usuario-id"
}
```

El backend debería comprobar que el encuentro existe, no ha expirado y no ha sido capturado anteriormente.

## Capturas del usuario

### GET `/api/capturas/usuario/{userId}`

Obtendría el historial de capturas del usuario.

Ejemplo:

```http
GET /api/capturas/usuario/usuario-id
```

No requiere body.

Respuesta propuesta:

```json
[
  {
	"id": 1,
	"idEncuentro": 101,
	"idPokemon": 25,
	"nombre": "pikachu",
	"fechaCaptura": "2026-09-30T12:10:00Z"
  }
]
```

## Intentar capturar un encuentro

### POST `/api/capturas/{id}/intentar`

Intentaría capturar el encuentro indicado.

Ejemplo:

```http
POST /api/capturas/101/intentar
```

Body propuesto:

```json
{
  "idItem": 1
}
```

El `idItem` podría utilizarse para lanzar una Poké Ball u otro objeto de captura.

Respuesta propuesta si tiene éxito:

```json
{
  "capturado": true,
  "mensaje": "Pokémon capturado correctamente.",
  "idPokemonUser": 12,
  "idPokemon": 25
}
```

Respuesta propuesta si falla:

```json
{
  "capturado": false,
  "mensaje": "El Pokémon escapó."
}
```

## Estado actual

Para implementar estas rutas posteriormente sería necesario añadir entidades para los encuentros y capturas. Los endpoints de catálogo de Pokémon ya disponibles no crean capturas automáticamente.

