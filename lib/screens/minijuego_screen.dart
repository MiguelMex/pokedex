import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/widgets/menu_card.dart';
import 'package:flutter/material.dart';

/**
 * Miniji¡uegos disponibles
 * a) Capyura
 * b) Batalla
 * c) Tamagochi
 */

class MinijuegoScreen extends StatelessWidget {
  const MinijuegoScreen({super.key});

  void _ir(BuildContext context, String titulo, IconData icono){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProximamenteScreen(titulo: titulo, icono: icono))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const  Text('Minijuego'),),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlack, kRedDark]
          )
        ),

        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Elige tu aventura',
                style: TextStyle(
                  color: kBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),

              //Captura
              const SizedBox(height: 16),
              MenuCard(
                horizontal: true,
                icono: Icons.view_in_ar_rounded,
                titulo: 'Captura AR',
                subtitulo: 'Atrapa los pokemones en relidad aumentada',
                onTap: () => _ir(context, 'Captura AR', Icons.view_in_ar_rounded)
              ),

              //Batalla
              const SizedBox(height: 16),
              MenuCard(
                horizontal: true,
                icono: Icons.flash_on_rounded,
                titulo: 'Batalla',
                subtitulo: 'Enfrenta a otros entrenadores',
                onTap: () => _ir(context, 'Batalla', Icons.flash_on_rounded)
              ),

              //Tamagochi
              const SizedBox(height: 16),
              MenuCard(
                horizontal: true,
                icono: Icons.view_in_ar_rounded,
                titulo: 'Tamagotchi',
                subtitulo: 'Cuida a tu pokemon',
                onTap: () => _ir(context, 'Tamagotchi', Icons.pets_rounded)
              ),


            ],
          ),
        )
      ),
    );
  }
}