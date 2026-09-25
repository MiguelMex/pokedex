import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class AudioHelper {

  //---Singleton---
  /**
   * Maneja la musica de fondo, siempre suena
   */
  AudioHelper._();
  static final AudioHelper instance = AudioHelper._();

  final AudioPlayer _bgPlayer = AudioPlayer();

  //Instancias de players, evitan sobreponerse unos sobre otros
  static const int _sfxPoolSize = 4;
  final List<AudioPlayer> _sfxPool = [];
  final List<bool> _sfxBusy = [];

  bool _initialized = false;
  String? _currentBg; //La musica de fondo que suena en el momento

  static final AudioContext _bgContext = AudioContext(
    android: AudioContextAndroid(
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gainTransientMayDuck,
      stayAwake: true,
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: const {AVAudioSessionOptions.mixWithOthers},
    ),
  );

  static final AudioContext _sfxContext = AudioContext(
    android: AudioContextAndroid(
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
      stayAwake: false,
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: const <AVAudioSessionOptions>{},
    ),
  );

  Future<void> init() async {
    debugPrint('AudioHelper.init() start');
    if(_initialized) {
      debugPrint('AudioHelper.init() skipped (already initialized)');
      return;
    }
    _initialized =  true;

    //loop
    try {
      await _bgPlayer.setAudioContext(_bgContext);
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(0.6);
      debugPrint('BG player configured');
    } catch (e, s){
      debugPrint('BG setup failed: $e\n$s');
    }

    //players para sfx
    for(var i = 0; i < _sfxPoolSize; i++){
      final p = AudioPlayer();
      await p.setAudioContext(_sfxContext);
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(1.0);

      //liberar cuando el audio termine
      p.onPlayerComplete.listen((_){
        final idx = _sfxPool.indexOf(p);
        if (idx != -1) _sfxBusy[idx] = false;
      });

      _sfxPool.add(p);
      _sfxBusy.add(false);
    }
  }

  //Backkground music

  //inicia o reinicia la musica
  Future<void> playBackgroundAudio(String asset, {bool restart = false}) async {
    debugPrint('Play Background audio');
    if (!_initialized) await init();

    if(!restart && _currentBg == asset && _bgPlayer.state == PlayerState.playing){
      return;
    }

    _currentBg = asset;
    await _bgPlayer.stop();
    await _bgPlayer.play(AssetSource(asset));
  }

  Future<void> pauseBackground() => _bgPlayer.pause();
  Future<void> resumeBackground() => _bgPlayer.resume();

  Future<void> stopBackground() async {
    _currentBg = null;
    await _bgPlayer.stop();
  }

  //Sfx

  //Reproduce el efecto sobre el audio de fondo
  Future<void> playSoundEffect(String asset, bool online) async {
    if(!_initialized) await init();

    //obten un player libre
    var slot = _sfxBusy.indexOf(false);
    if(slot == -1){
      slot = 0;
      await _sfxPool[slot].stop();
    }

    _sfxBusy[slot] = true;
    final player = _sfxPool[slot];

    final source = online ? UrlSource(asset) : AssetSource(asset);
    await player.play(source, mode: PlayerMode.lowLatency);
  }

  Future<void> dispose() async {
    await _bgPlayer.dispose();
    for(final p in _sfxPool) {
      await p.dispose();
    }
    _sfxPool.clear();
    _sfxBusy.clear();
    _initialized = false;
  }

}