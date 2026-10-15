/*
NOTA:
Se estará trabajando la interfaz de las credenciales de usuario,
en ese caso inicio de sesión o registro.

componentes basicos como los de siempre
*/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/providers/poke_api_provider.dart';


// ___________________________ Inicia la clase __________________
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key}); //constructor

  @override
  State<AuthScreen> createState() => _AuthScreenState();
  
}


class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool _esLogin = true; //true = Login  | false = registro
  bool _verPassword = false; 
  
  //Controladores
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  //Animación de la pokebola flotando
  late final AnimationController _floatController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  ).. repeat(reverse: true);


  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  //Para LOGIN
  void _handleLogin() async {
    final authProvider = context.read<AuthProvider>();
    final ok = await authProvider.login(
      _userNameController.text.trim(),
      _passwordController.text,
      
    );

    if(ok && mounted){
      Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreen())); //Ajustando la ruta real
    }
  }


  //Para REGISTER
  void _handleRegister() async {
    final authProvider = context.read<AuthProvider>();
    final ok = await authProvider.register(
      _userNameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,

    );

    if(ok && mounted){
      setState(() => _esLogin = true ); //pasa a iniciar sesión
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Usuario registrado! Ya puedes iniciar sesión'))
      );
    }

  }


 //___________________________ Parte del diseño UI/UX __________________
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esLogin ? 'Iniciar sesión' : 'Registro')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlack, kRedDark],
          ),
        ),

        child: Stack(
          children: [
            //Pokebolas decorativas de fondo
            Positioned(
              top: -70,
              right: -70,
              child: Transform.rotate(
                angle: 0.4,
                child: const _pokeball(size: 220, opacity: 0.10), //llama la clase/metodo
              ),
            ),

            Positioned(
              bottom: -90,
              left: -80,
              child: Transform.rotate(
                angle: -0.5,
                child: const _pokeball(size: 260, opacity: 0.10),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          _buildHeader(), //llama metodo/clase
                          const SizedBox(height: 14),


                          //Chips de bienvenida
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _chip(Icons.catching_pokemon, 'Pokédex'),
                              _chip(Icons.layers_rounded, 'Generaciones'),
                            ],
                          ),

                          const SizedBox(height: 24),

                          _buildCard(),
                          const SizedBox(height: 20),
                          const Text(
                            '¡Atrapalos ya!',
                            style: TextStyle(
                              color: kBlackSoft,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.2,

                            ),
                          ),


                        ],
                      ),
                    ),
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }


  //_________________________ Metodo: Chip Pequeño para la zona de bienvenida ________________
  Widget _chip(IconData icon, String texto){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kRedDark.withValues(alpha: 0.5)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: kBlue),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(color: Colors.white, fontSize: 12),

          ),

        ],
      ),

    );

  }



  // _______________________ Metodo: parte de la animación______________
  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _floatController,
          builder:(context, child) {
            final dy = -10 * Curves.easeInOut.transform(_floatController.value);
            return Transform.translate(
              offset: Offset(0, dy),
              child: child,
            );
          },

          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kBlueSoft.withValues(alpha: 0.35),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),

            child: const _pokeball(size: 96), //llama el metodo o clase
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          'POKECLASE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),

        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            //condición
            _esLogin
              ? 'Bienvenido de vuelta, entrenador!'
              : 'Crea tu perfil de entrenador',

            key: ValueKey(_esLogin),
            style: const TextStyle(color: kBlueSoft, fontSize: 15),
          ),
        ),

      ],
    );
  }


  //_____________________ metodo: ______________
  Widget _buildCard(){
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: kBlueSoft, width: 2),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 24,
            offset: const Offset(0, 12),

          ),
        ],
      ),

      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggle(), //llama metodo
              const SizedBox(height: 22),

              //campos para ingresar los datos
              _campo(
                controller: _userNameController,
                label: 'Usuario',
                icon: Icons.person_3_rounded,
              ),
              const SizedBox(height: 16),
              

              //El correo aparece con animación solo en registro
              AnimatedSize(
                duration: const Duration(microseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _esLogin
                  ? const SizedBox(width: double.infinity)
                  : Column(
                    children: [
                      _campo(
                        controller: _emailController,
                        label: 'Correo',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

              ),

              _campo(
                controller: _passwordController,
                label: 'Contraseña',
                icon: Icons.lock_rounded,
                obscure: !_verPassword,
                suffix: IconButton(
                  icon: Icon(
                    _verPassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                    color: kRedDark,
                  
                  ),
                  onPressed: () =>
                    setState(() => _verPassword = !_verPassword),

                  ),
                ),
                const SizedBox(height: 20),

                if(authProvider.error != null) _buildError(authProvider.error!),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: authProvider.cargando ? const Center(child: CircularProgressIndicator(color: kRed),)
                    :ElevatedButton.icon(
                      onPressed: _esLogin ? _handleLogin : _handleRegister, //ajustes
                      icon: const Icon(Icons.catching_pokemon),
                      label: Text(
                        _esLogin ? 'Entrar' : 'registrarme',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlueSoft,
                        foregroundColor: kBlackSoft,
                        disabledBackgroundColor: kRed.withValues(alpha: 0.45),
                        disabledForegroundColor: kRed.withValues(alpha: 0.5),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(16),

                        ),
                      ),
                    ),


                ),
      
            ],
          );
        },
      ),

    );
  }

  
  //Selector tipo pildora Login/ Registro
  Widget _buildToggle() {
    Widget tab(String texto, bool seleccionado, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(microseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: seleccionado ? kRed : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Center(
              child: Text(
                texto,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: seleccionado ? Colors.white : kBlack,

                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kBlue,
        borderRadius: BorderRadius.circular(18),

      ),
      child: Row(
        children: [
          tab('Iniciar sesión', _esLogin, () => setState(() => _esLogin = true)),
          tab('Registro', !_esLogin, () => setState(() => _esLogin = false)),

        ],
      ),
    );
  }

  
  Widget _buildError (String mensaje) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.6)),

      ),

      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 20,
          ),

          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mensaje,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 13
              ),
            ),
          ),
        ],
      ),
    );
  }


  //campo de texto reutilizado con el estilo de la app
  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }){

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      cursorColor: kRed,
      style: const TextStyle(color: kBlackSoft),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kBlack.withValues(alpha: 0.6)),
        floatingLabelStyle: const TextStyle(color: kRed),
        prefixIcon: Icon(icon, color: kRed),
        suffixIcon: suffix,
        filled: true,
        fillColor: kBlue,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kRed, width: 2),

        ),
      ),
    );
  }
  
}

//_______________________________ CLASE: Pokebola dibujada con CustomPaint _______________________
class _pokeball extends StatelessWidget {
  final double size;
  final double opacity;
  const _pokeball({required this.size, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _pokeballPainter(opacity: opacity), //llama el metodo

    );
  }

  
}



//________________  Nueva Clase: pokeballPainter  ____________________
class _pokeballPainter extends CustomPainter {
  final double opacity;

  _pokeballPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width/ 2;
    final center = Offset(r, r);
    final rect = Rect.fromCircle(center: center, radius: r);
    final banda = size.width * 0.09;

    final top = Paint()..color = kBlackSoft.withValues(alpha: opacity);
    final bottom = Paint()..color = kBlackSoft.withValues(alpha: opacity);
    final linea = Paint()..color = kBlack.withValues(alpha: opacity);


    //Mitades (divide el circulo)
    canvas.save();
    canvas.clipPath(Path()..addOval(rect));
    canvas.drawArc(rect, math.pi, math.pi, true , top); //arriba
    canvas.drawArc(rect, 0, math.pi, true , bottom); //abajo
    canvas.drawRect(Rect.fromLTWH(0, r - banda/ 2, size.width, banda), linea); //banda central
    canvas.restore();

    //contorno
    canvas.drawCircle(center,
      r - banda/ 4,
      Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = banda/ 2
      ..color = kBlack.withValues(alpha: opacity),
    );

    //Botón central
    canvas.drawCircle(center, r * 0.27, linea);
    canvas.drawCircle(
      center,
      r * 0.17,
      Paint()..color = Colors.white.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(covariant _pokeballPainter old) => old.opacity != opacity;

  
}