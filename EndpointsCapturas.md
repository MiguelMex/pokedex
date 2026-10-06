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
