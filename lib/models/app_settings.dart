class AppSettings {
  String background_song;

  AppSettings({
    this.background_song = 'audio/music/02-title-screen.mp3',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    background_song: json['background_song'] as String? ?? 'audio/music/02-Title-Screen.mp3',
  );

  Map<String, dynamic> toJson() => {
    'background_song': background_song,
  };

  AppSettings copyWith({
    String? background_song,
  }) => AppSettings(
    background_song: background_song ?? this.background_song,
  );
}