import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';

// const _kPrimary = Color(0xFF5345AB);
// const _kSecundary = Color(0xFFE5D36D);
// const _kDark = Color(0xFF1E2240);

class MenuCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final bool horizontal;

  const MenuCard({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.horizontal = false
  });

  @override
  Widget build(BuildContext context) {
    final borde = BorderRadius.circular(22);
    final insignia = Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(color: kRedDark, shape: BoxShape.circle),
      child: Icon(icono, color: Colors.white, size: 30),
    );

    final textos = [
      Text(
        titulo,
        style: const TextStyle(
          color: kBlueSoft,
          fontSize: 16,
          fontWeight: FontWeight.w800
        ),
      ),

      const SizedBox(height: 4,),
      Text(
        subtitulo,
        textAlign: horizontal ? TextAlign.start : TextAlign.center,
        style: TextStyle(color: kBlueSoft.withValues(alpha: 0.6), fontSize: 12),
      ),
    ];
    return Material(
      color: kBlackSoft,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: borde,
        side: const BorderSide(color: kBlue, width: 2),
      ),

      child: InkWell(
        borderRadius: borde,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: horizontal ? Row(
            children: [
              insignia,
              const SizedBox(width: 16,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: textos,
                ),
              ),

              const Icon(Icons.chevron_left_rounded, color: kRedDark),
            ],
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [insignia, const SizedBox(height: 12,), ...textos],
          )
        ),
      ),
    );
  }
}

//Pantalla temporal
class ProximamenteScreen extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const ProximamenteScreen({
    required this.titulo,
    required this.icono
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlack, kBlackSoft],
          )
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 80,
              color: kRedDark,
            ),

            const SizedBox(height: 16,),
            const Text(
              'Proximamente',
              style: TextStyle(
                color: kBlue,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            )
          ],
        ),
      )
    );
  }
}