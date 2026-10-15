//Nucleo de la aplicación

import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/screens/auth_screen.dart';
import 'package:pokedex/screens/generation_list_screen.dart';
import 'package:pokedex/screens/minijuego_screen.dart';
import 'package:pokedex/widgets/general_appbar.dart';
import 'package:pokedex/widgets/menu_card.dart';

// const _kPrimary = Color(0xFF5345AB);
// const _kSecundary = Color(0xFFE5D36D);
// const _kDark = Color(0xFF1E2240);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _ir(BuildContext context, Widget pantalla){
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GeneralAppbar(title: 'Dashboard'),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlack, kBlackSoft],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Hola entrenador!',
                  style: TextStyle(
                    color: kBlue,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4,),
                const Text(
                  '¿Que quieres hacer hoy?',
                  style: TextStyle(color: kBlueSoft, fontSize: 15),
                ),

                const SizedBox(height: 24,),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,

                    children: [
                      //Intercambio
                      MenuCard(
                        icono: Icons.swap_horiz_rounded,
                        titulo: 'Intercambio',
                        subtitulo: 'Cambia Pokemon con otros',
                        onTap: () => _ir(
                          context,
                          const ProximamenteScreen(
                            titulo: 'Intercambio',
                            icono: Icons.swap_horiz_rounded
                          ),
                        ),
                      ),

                      //Capturados
                      MenuCard(
                        icono: Icons.catching_pokemon,
                        titulo: 'Capturados',
                        subtitulo: 'Tu coleccion',
                        onTap: () => _ir(
                          context,
                          const ProximamenteScreen(
                            titulo: 'Capturados',
                            icono: Icons.catching_pokemon
                          ),
                        ),
                      ),

                      //Pokedex
                      MenuCard(
                        icono: Icons.catching_pokemon,
                        titulo: 'Pokedex',
                        subtitulo: 'Explora las generaciones',
                        onTap: () => _ir(
                          context,
                          GenerationListScreen()
                        ),
                      ),

                      //Minijuegos
                      MenuCard(
                        icono: Icons.sports_esports_rounded,
                        titulo: 'Minijuegos',
                        subtitulo: 'Captura, batalla y más',
                        onTap: () => _ir(
                          context,
                          const MinijuegoScreen()
                        ),
                      ),

                    ],
                  ),
                )
              ],
            )
          ),
        ),
      )
    );
  }
}