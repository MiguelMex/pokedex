import 'package:flutter/material.dart';
import 'package:pokedex/helpers/audio_helper.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/screens/generation_list_screen.dart';
import 'dart:math' as math;

class TitleScreenAnimated extends StatefulWidget {
  const TitleScreenAnimated({super.key});

  @override
  State<TitleScreenAnimated> createState() => _TitleScreenAnimatedState();
}

class _TitleScreenAnimatedState extends State<TitleScreenAnimated> {
  final Map<int, Offset> _ripples = {};
  int _nextRipped = 0;

  void _addRipple(Offset position){
    final id = _nextRipped++;
    setState(() => _ripples[id] = position);
  }

  void _removeRipple(int id){
    if(!mounted) return;
    setState(() => _ripples.remove(id));
  }

  Future<void> _handleTap() async {
    await AudioHelper.instance.playSoundEffect('audio/shiny-pokemon.mp3', false);
    if(!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GenerationListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _addRipple(details.localPosition),
        onTap: _handleTap,
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
                    child: TextAnimation(
                      label: 'TAP SCREEN TO START',
                      glowColor: kBlueSoft,
                    ),
                  ),
                ],
              ),
            ),

            //Tap ripples
            for(final entry in _ripples.entries)
              _RippleWidget(
                key: ValueKey(entry.key),
                position: entry.value,
                onComplete: () => _removeRipple(entry.key),
              )
          ],
        ),
      )
    );
  }
}

//TextAnimation
class TextAnimation extends StatefulWidget {
  final String label;
  final Color glowColor;
  final Duration period;

  const TextAnimation({super.key, required this.label, required this.glowColor, this.period = const Duration(milliseconds: 2000)});

  @override
  State<TextAnimation> createState() => _TextAnimationState();
}

class _TextAnimationState extends State<TextAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.period,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // ── Smooth, kink-free breathing pulse ──
          // Two sine waves at different frequencies combine into an
          // organic "alive neon" feel — no abrupt holds, no curve seams.
          final phase = _controller.value * 2 * math.pi;
          final slow = (math.sin(phase) + 1) / 2;                     // main breath
          final fast = (math.sin(phase * 3 + math.pi / 4) + 1) / 2;   // subtle texture
          final blend = 0.80 * slow + 0.20 * fast;                    // 0..1, always smooth

          // Shape the perceived intensity: spend more time dim,
          // briefly peak. Reads as flicker without any stutter.
          final intensity = math.pow(blend, 1.6).toDouble();          // 0..1

          final glow = widget.glowColor;

          final borderColor = Color.lerp(kBlackSoft, glow, intensity * 0.6)!;

          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 3, color: borderColor),
                bottom: BorderSide(width: 3, color: borderColor),
              ),
              // Three-layer halo, each layer scaled by intensity so the
              // outer aura "breathes" more than the tight core.
              boxShadow: [
                BoxShadow(
                  color: glow.withValues(alpha: 0.35 * intensity),
                  blurRadius: 16 * intensity,
                  spreadRadius: 1.5 * intensity,
                ),
                BoxShadow(
                  color: glow.withValues(alpha: 0.20 * intensity),
                  blurRadius: 42 * intensity,
                  spreadRadius: 5 * intensity,
                ),
                BoxShadow(
                  color: glow.withValues(alpha: 0.10 * intensity),
                  blurRadius: 80 * intensity,
                  spreadRadius: 10 * intensity,
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: kBlack,
                // Staggered shadow layers with core + halo sizes
                // driven by intensity. The added baseline (4, 12, 30)
                // keeps a faint glow even at intensity 0, so the text
                // never fully dies.
                shadows: [
                  Shadow(
                    color: glow.withValues(alpha: 0.95 * intensity),
                    blurRadius: 4 + 4 * intensity,
                  ),
                  Shadow(
                    color: glow.withValues(alpha: 0.65 * intensity),
                    blurRadius: 12 + 8 * intensity,
                  ),
                  Shadow(
                    color: glow.withValues(alpha: 0.35 * intensity),
                    blurRadius: 30 + 12 * intensity,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
//Tap animation
  class _RippleWidget extends StatefulWidget {
    final Offset position;
    final VoidCallback onComplete;

    const _RippleWidget({
      super.key,
      required this.position,
      required this.onComplete,
    });      
  
    @override
    State<_RippleWidget> createState() => __RippleWidgetState();
  }
  
  class __RippleWidgetState extends State<_RippleWidget> with SingleTickerProviderStateMixin{
    static const double _maxRadius = 180;

    late final AnimationController _controller;
    late final Animation<double> _radius;
    late final Animation<double> _opacity;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 650),
      );

      final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

      _radius = Tween<double>(begin: 10, end: _maxRadius).animate(curve);
      _opacity = Tween<double>(begin: 0.7, end: 0.0).animate(curve);

      _controller.addStatusListener((status){
        if(status == AnimationStatus.completed){
          widget.onComplete();
        }
      });

      _controller.forward();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final r = _radius.value;
          return Positioned(
            left: widget.position.dx -r,
            top: widget.position.dy - r,
            child: IgnorePointer(
              child: Container(
                width:  r * 2,
                height: r * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kBlue.withValues(alpha: _opacity.value),
                    width: 10,
                  )
                ),
              ),
            )
          );
        }
      );
    }
  }