import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/helpers/audio_helper.dart';
import 'package:pokedex/helpers/storage_helper.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/models/app_settings.dart';

class MusicConfigScreen extends StatefulWidget {
  const MusicConfigScreen({super.key});

  @override
  State<MusicConfigScreen> createState() => _MusicConfigScreenState();
}

class _MusicConfigScreenState extends State<MusicConfigScreen> {
  static const String _settingsFile = 'settings.json';

  List<String> songAssetsList = [];
  String? selectedSong;
  bool _isLoading = true;

  final StorageHelper _storage = StorageHelper();

  Future<void> _initSongs() async{
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final songs = assetManifest.listAssets().where((path) => path.startsWith("assets/audio/music")).toList();

    //Get song from settings
    final settingsJson = await _storage.readJson(_settingsFile);
    final settings = AppSettings.fromJson(settingsJson);

    final savedPath = 'assets/${settings.background_song}';

    if(!mounted) return;
    setState(() {
      songAssetsList = songs;
      selectedSong = songs.contains(savedPath) ? savedPath : (songs.isNotEmpty ? songs.first : null);
      _isLoading = false;
    });
  }

  String _prettyName(String path){
    final file = path.split('/').last;
    final withoutExt = file.contains('.')
      ? file.substring(0, file.lastIndexOf('.'))
      : file;

    return withoutExt;

  }

  void _applySelection(String assetPath) async{
    final audioSourcePath = assetPath.replaceFirst('assets/', '');

    final exisitingJson = await _storage.readJson(_settingsFile);
    final settings = AppSettings.fromJson(exisitingJson).copyWith(background_song: audioSourcePath);
    await _storage.writeJson(_settingsFile, settings.toJson());

    final newData = await _storage.readJson(_settingsFile);
    final newDataFormated = AppSettings.fromJson(newData);
    debugPrint('New Data: ${newDataFormated.background_song}');

    try {
      AudioHelper.instance.playBackgroundAudio(audioSourcePath);
    } catch (e) {
      debugPrint('Failed at playing song');
    }
  }

  @override
  void initState() {
    super.initState();
    _initSongs();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(
            Icons.catching_pokemon_sharp,
            color: Colors.white,
          ),
          SizedBox(width: 12,)
        ],
        title: Text(
          'Opciones de audio',
          style: TextStyle(
            color: kBlackSoft,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
              : songAssetsList.isEmpty
                ? const Text(
                  'No songs found',
                  style: TextStyle(
                    color: Colors.white
                  )
                ) 
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Background song',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    DropdownButtonFormField<String>(
                      initialValue: selectedSong,
                      isExpanded: true,
                      dropdownColor: kBlackSoft,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: songAssetsList.map((song){
                        return DropdownMenuItem<String>(
                          value: song,
                          child: Text(
                            _prettyName(song),
                            overflow: TextOverflow.ellipsis,
                          )
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if(value == null) return;
                          setState(() {
                            selectedSong = value;
                          });
                          selectedSong = value;
                          _applySelection(value);
                        });
                      }
                    )
                  ],
                )
          ),
        ),
      ),
    );
  }
}