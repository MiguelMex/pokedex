import 'package:flutter/material.dart';
import 'package:pokedex/screens/auth_screen.dart';
import 'package:pokedex/screens/generation_list_screen.dart';

class GeneralAppbar extends StatefulWidget implements PreferredSizeWidget{
  final bool isLoggedIn = true; //Esto es para comprobbar a futuro si el usuario esta loggeado
  final String title;

  const GeneralAppbar({super.key, required this.title});

  @override
  State<GeneralAppbar> createState() => _GeneralAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _GeneralAppbarState extends State<GeneralAppbar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
      ),
      actions: [
        IconButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => widget.isLoggedIn? GenerationListScreen() : AuthScreen(),
              )
            );
          },
          icon: Icon(
            widget.isLoggedIn? Icons.settings : Icons.login,
            color: Colors.white,
          )
        )
      ],
    );
  }
}