import 'package:flutter/material.dart';

Color getTypeColor(String type) {
  switch (type) {
    case 'fire':     return Colors.orange;
    case 'water':    return Colors.blue;
    case 'grass':    return Colors.green;
    case 'electric': return Colors.yellow;
    case 'poison':   return Colors.purple;
    case 'flying':   return Colors.lightBlue;
    case 'bug':      return Colors.lightGreen;
    case 'normal':   return Colors.grey;
    case 'fighting': return Colors.redAccent;
    case 'psychic':  return Colors.purpleAccent;
    case 'dragon':   return Colors.lightBlueAccent;
    case 'ghost':    return Colors.deepPurple;
    case 'dark':     return Colors.black;
    case 'ground':   return Colors.brown;
    case 'fairy':    return Colors.pinkAccent;
    case 'rock':     return const Color.fromARGB(255, 85, 59, 30);
    case 'ice':      return Colors.lightBlue;
    case 'steel':    return Colors.blueGrey;
    default:         return Colors.white;
  }
}

Color getTypeBorder(String type) {
  switch (type) {
    case 'fire':     return const Color.fromARGB(255, 163, 98, 0);
    case 'water':    return const Color.fromARGB(255, 20, 88, 143);
    case 'grass':    return const Color.fromARGB(255, 42, 97, 44);
    case 'electric': return const Color.fromARGB(255, 170, 157, 40);
    case 'poison':   return const Color.fromARGB(255, 102, 26, 116);
    case 'flying':   return const Color.fromARGB(255, 3, 114, 165);
    case 'bug':      return const Color.fromARGB(255, 87, 122, 46);
    case 'normal':   return const Color.fromARGB(255, 107, 107, 107);
    case 'fighting': return const Color.fromARGB(255, 151, 51, 51);
    case 'psychic':  return const Color.fromARGB(255, 118, 35, 133);
    case 'dragon':   return const Color.fromARGB(255, 39, 117, 153);
    case 'ghost':    return const Color.fromARGB(255, 49, 28, 87);
    case 'dark':     return const Color.fromARGB(255, 31, 31, 31);
    case 'ground':   return const Color.fromARGB(255, 73, 52, 44);
    case 'fairy':    return const Color.fromARGB(255, 175, 44, 88);
    case 'rock':     return const Color.fromARGB(255, 48, 33, 17);
    case 'ice':      return const Color.fromARGB(255, 3, 109, 158);
    case 'steel':    return const Color.fromARGB(255, 54, 70, 78);
    default:         return const Color.fromARGB(255, 153, 151, 151);
  }
}