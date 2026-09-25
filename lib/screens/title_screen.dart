import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/screens/generation_list_screen.dart';
import 'package:pokedex/helpers/audio_helper.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  //lib/assets/images/millenium.jpg
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: InkWell(
        onTap: () async{
          await AudioHelper.instance.playSoundEffect('audio/shiny-pokemon.mp3', false).then(
            (audio) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerationListScreen())
              );
            }
          );
          
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            
            const DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pokedex.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        
            SafeArea(
              child: Column(
                children: [
        
                  const Spacer(),
        
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 3, color: kBlackSoft),
                          bottom: BorderSide(width: 3, color: kBlackSoft),
                        ),
                      ),
                      child: const Text(
                        'TAP SCREEN TO START',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: kBlack,
                          shadows: [
                            Shadow(
                              color: kBlackSoft,
                              blurRadius: 25,
                            )
                          ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}