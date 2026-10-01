import 'package:flutter/material.dart';
import 'package:pokedex/helpers/audio_helper.dart';
import 'package:pokedex/helpers/storage_helper.dart';
import 'package:pokedex/models/app_settings.dart';
import 'package:pokedex/providers/poke_api_provider.dart';
import 'package:pokedex/screens/title_screen.dart';
import 'package:pokedex/screens/title_screen_Animated.dart';
import 'package:provider/provider.dart';

const String _settingsFile = 'settings.json';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  AudioHelper.instance.init();
  final storage = StorageHelper();

  final settingsJson = await storage.readJson(_settingsFile);
  final settings = AppSettings.fromJson(settingsJson);
  debugPrint('Settings file is: ${settings.background_song}');

  try{
    await AudioHelper.instance.playBackgroundAudio(settings.background_song);
  } catch (e) {
    debugPrint('Could not start background audio: $e');
  }
  
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PokeApiProvider(),
          lazy: false,
        )
      ],
      child: MyApp(),
    );
  }
}

// ─────────────────────────────────────────────
// POKÉDEX PALETTE — red, black, blue
// ─────────────────────────────────────────────
const kRed   = Color(0xFFE3350D); // Pokédex red
const kBlack = Color(0xFF1A1A1A); // bezel black
const kBlue  = Color(0xFF3B7DD8); // screen blue

// Minimal supporting shades
const kRedDark  = Color(0xFFB32200);
const kBlackSoft = Color(0xFF2A2A2A);
const kBlueSoft  = Color(0xFF6FA8E8);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poke Clase',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary:            kRed,
          onPrimary:          Colors.white,
          primaryContainer:   kRedDark,
          onPrimaryContainer: Colors.white,

          secondary:          kBlue,
          onSecondary:        Colors.white,
          secondaryContainer: kBlueSoft,
          onSecondaryContainer: kBlack,

          surface:            kBlackSoft,
          onSurface:          Colors.white,
          surfaceContainer:   kBlack,

          outline:            kBlue,
        ),
        scaffoldBackgroundColor: kBlack,

        appBarTheme: const AppBarTheme(
          backgroundColor: kRed,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        cardTheme: CardThemeData(
          color: kBlackSoft,
          elevation: 4,
          surfaceTintColor: Colors.transparent,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        ),

        listTileTheme: const ListTileThemeData(
          tileColor: Colors.transparent,
          textColor: Colors.white,
          iconColor: kBlue,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kBlue,
          foregroundColor: Colors.white,
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: kRed,
            foregroundColor: Colors.white,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kBlue,
            side: const BorderSide(color: kBlue, width: 2),
          ),
        ),

        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: kBlue,
          linearTrackColor: kBlackSoft,
        ),

        dividerTheme: const DividerThemeData(
          color: kBlue,
          thickness: 1,
        ),
      ),
      home: const TitleScreenAnimated(),
    );
  }
}

// const _KPrimary = Color(0xFF5345AB);
// const _KSecondary = Color(0xFFE5D36D);
// const _KSurfaceVariant = Color(0xFFB8BDD5);
// const _KDart = Color(0xFF1E2240);



// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'poke Clase',
//       theme: ThemeData(
//         useMaterial3: true,
//         scaffoldBackgroundColor: _KSurfaceVariant,
//         colorScheme: const ColorScheme.dark(
//           primary: _KPrimary,
//           onPrimary: Colors.white,
//           secondary: _KSecondary,
//           onSecondary: _KDart,
//           surface: _KSurfaceVariant,
//           onSurface: _KDart,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: _KPrimary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//         ),
//         listTileTheme: const ListTileThemeData(
//           tileColor: Colors.white,
//           textColor: _KDart,
//           iconColor: _KPrimary,
//         ),
//         floatingActionButtonTheme: const FloatingActionButtonThemeData(
//           backgroundColor: _KSecondary,
//           foregroundColor: _KDart,
//         ),
//       ),
//       home: const GenerationListScreen(),
//     );
//   }
// }