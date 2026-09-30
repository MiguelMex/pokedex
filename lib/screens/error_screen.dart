import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Column(
            children: [
              Image.asset(
                'images/error.jpg'
              )
            ],
          )
        ],
      );
  }
}