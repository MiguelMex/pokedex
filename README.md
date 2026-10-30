# 🔴 Poke Clase — Pokédex en Flutter

Aplicación móvil/escritorio/web desarrollada en **Flutter** que funciona como una Pokédex interactiva. Consume la [PokéAPI](https://pokeapi.co/) para explorar los Pokémon por generación y se conecta a un backend propio para autenticación de usuarios y minijuegos (captura, batalla y Tamagotchi).

La interfaz sigue una paleta inspirada en la Pokédex clásica: **rojo, negro y azul**, con música de fondo, efectos de sonido y los gritos (cries) de cada Pokémon.

---

## ✨ Características

### Pokédex
- **Pantalla de título animada** con efecto de brillo pulsante y ondas al tocar la pantalla.
- **Dashboard** principal con acceso a: Intercambio, Capturados, Pokédex y Minijuegos.
- **Generaciones**: lista de las 9 regiones (Kanto, Johto, Hoenn, Sinnoh, Teselia, Kalos, Alola, Galar y Paldea) con imagen de fondo propia.
- **Listado por generación**: cuadrícula de 3 columnas con el artwork oficial y número de cada Pokémon.
- **Detalle del Pokémon**:
  - Carrusel de sprites (official-artwork, home, dream world, showdown y sprites de cada versión de juego).
  - Tipos y estadísticas base con barras de progreso.
  - Habilidades con su descripción (consultadas a `/ability`).
  - Reproducción automática del grito del Pokémon y botón para repetirlo.
  - Colores dinámicos según el tipo primario.
- **Información de especie**: entradas de la Pokédex por versión, género, perfil (generación, hábitat, color, forma, ritmo de crecimiento), cría (ratio de género, captura, felicidad, pasos de eclosión, grupos huevo), otras formas y pre‑evolución.

### Audio
- Música de fondo en bucle, configurable desde la pantalla **Opciones de audio** (se guarda en `settings.json`).
- Pool de reproductores para efectos de sonido sin que se pisen entre sí.
- Reproducción de gritos de Pokémon desde URL.

### Cuenta de usuario
- Inicio de sesión y registro contra el backend propio (JWT).
- Pantalla con pokébola dibujada con `CustomPaint` y animación flotante.

### Minijuegos *(en desarrollo)*
- 📷 **Captura AR**
- ⚔️ **Batalla**
- 🐾 **Tamagotchi**

---

## 🛠️ Tecnologías y dependencias

| Paquete | Uso |
|---|---|
| `flutter` (SDK `>=3.44.0`) / Dart `^3.13.0` | Framework |
| `provider` | Gestión de estado (`PokeApiProvider`, `AuthProvider`) |
| `http` | Peticiones a PokéAPI y al backend |
| `audioplayers` | Música de fondo, efectos y gritos |
| `auto_size_text` (desde GitHub) | Texto que se ajusta al espacio disponible |
| `cupertino_icons` | Iconos |
| `path_provider` | Ruta de almacenamiento para `settings.json` |

Plataformas configuradas: **Android**, **Linux** y **Web**.

---

## 📁 Estructura del proyecto

```
lib/
├── main.dart                      # Punto de entrada, tema y paleta de colores
├── helpers/
│   ├── audio_helper.dart          # Singleton de audio (fondo + SFX)
│   └── storage_helper.dart        # Lectura/escritura de archivos JSON locales
├── models/
│   ├── app_settings.dart          # Configuración local (canción de fondo)
│   ├── auth_response.dart         # Login / registro
│   ├── battle_response.dart       # Batallas, estados, objetos del usuario
│   ├── capture_response.dart      # Capturas y coordenadas
│   ├── generation_list_response.dart
│   ├── generation_detail_response.dart
│   ├── pokemon_detail_response.dart
│   ├── pokemon_species_response.dart
│   ├── pokemon_ability_response.dart
│   └── tamagotchi_response.dart
├── providers/
│   └── poke_api_provider.dart     # PokeApiProvider + AuthProvider
├── screens/
│   ├── title_screen_Animated.dart # Pantalla de inicio (la usada actualmente)
│   ├── title_screen.dart          # Versión sin animación
│   ├── dashboard_screen.dart      # Menú principal
│   ├── auth_screen.dart           # Login / registro
│   ├── generation_list_screen.dart
│   ├── generation_detail_screen.dart
│   ├── pokeon_detail_screen.dart  # Detalle del Pokémon
│   ├── pokemon_species_screen.dart
│   ├── abilities_detail_screen.dart
│   ├── pokemon_type_colors.dart   # Colores por tipo
│   ├── music_config_screen.dart
│   ├── minijuego_screen.dart
│   ├── tamagotchi_screen.dart
│   └── error_screen.dart
└── widgets/
    ├── general_appbar.dart
    └── menu_card.dart             # Tarjeta de menú + pantalla "Próximamente"

assets/
├── audio/            # Efectos de sonido
│   └── music/        # Canciones de fondo seleccionables
└── images/           # Fondos de regiones, pantalla de título, etc.
```

---

## 🚀 Puesta en marcha

### Requisitos
- [Flutter](https://docs.flutter.dev/get-started/install) `>=3.44.0`
- Dart `^3.13.0`
- Git (la dependencia `auto_size_text` se descarga desde GitHub)

### Instalación

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd pokedex

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar
flutter run                  # dispositivo/emulador conectado
flutter run -d linux         # escritorio Linux
flutter run -d chrome        # web
```

> Asegúrate de que la carpeta `assets/` contenga las imágenes y audios referenciados en el código (por ejemplo `assets/audio/shiny-pokemon.mp3`, `assets/audio/music/02-title-screen.mp3` y las imágenes de cada región).

---

## 🌐 APIs utilizadas

### PokéAPI
`https://pokeapi.co/api/v2/` — endpoints usados: `generation`, `pokemon`, `pokemon-species` y `ability`. Los sprites se cargan desde `raw.githubusercontent.com/PokeAPI/sprites`.

### Backend propio
`BackPokemon.somee.com` — autenticación mediante `/api/Auth/login` y `/api/Auth/register`.

La documentación completa de los endpoints de **Batallas**, **Equipo Pokémon**, **Objetos**, **Tamagotchi** y **Capturas** está en [`AllEnpoints.md`](./AllEnpoints.md).

> ℹ️ Los endpoints propios de captura (`/api/encuentros`, `/api/capturas`) aparecen documentados como diseño y **aún no están implementados** en el backend.

---

## 🗺️ Estado del proyecto

- [x] Pantalla de título animada
- [x] Pokédex por generaciones
- [x] Detalle de Pokémon (sprites, stats, habilidades, especie)
- [x] Música de fondo configurable y efectos de sonido
- [x] Login y registro
- [ ] Capturados (colección del usuario)
- [ ] Intercambio entre entrenadores
- [ ] Captura en realidad aumentada
- [ ] Batallas
- [ ] Tamagotchi (modelo listo, pantalla pendiente)
- [ ] Pantalla de error funcional (`ErrorScreen`)

### Pendientes técnicos conocidos
- Añadir el permiso `INTERNET` al `AndroidManifest.xml` principal (actualmente solo está en los de *debug* y *profile*), de lo contrario la versión *release* no tendrá conexión.
- El backend usa `http` (sin TLS): en Android 9+ se requiere `usesCleartextTraffic` o migrar a `https`.
- Declarar `path_provider` como dependencia directa en `pubspec.yaml`.
- Corregir la ruta de la imagen en `ErrorScreen` (`images/error.jpg` → `assets/images/error.jpg`) y registrarla en los assets.
- Varios modelos (`CaptureResponse`, `Coordinates`, `TamagotchiResponse`, `Battle`) asignan directamente campos `DateTime` desde JSON; usar `DateTime.parse(...)`.
- Reemplazar `test/widget_test.dart` (es la plantilla del contador) por pruebas reales.

---

## 🎨 Paleta de colores

| Constante | Color | Uso |
|---|---|---|
| `kRed` | `#E3350D` | Rojo Pokédex, barras y botones |
| `kRedDark` | `#B32200` | Acentos |
| `kBlack` | `#1A1A1A` | Fondo (bisel) |
| `kBlackSoft` | `#2A2A2A` | Superficies y tarjetas |
| `kBlue` | `#3B7DD8` | Pantalla / acentos |
| `kBlueSoft` | `#6FA8E8` | Textos y bordes suaves |

---

## 📄 Licencia y créditos

Proyecto académico desarrollado con fines educativos. Pokémon y todos los nombres relacionados son marcas registradas de Nintendo, Game Freak y The Pokémon Company. Los datos provienen de [PokéAPI](https://pokeapi.co/).
