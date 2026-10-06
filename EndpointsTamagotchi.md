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
