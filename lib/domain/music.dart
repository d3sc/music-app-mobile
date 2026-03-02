class Music {
  final String id;
  final String title;
  final String artist;
  final String url;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['ID'].toString(),
      title: json['title'],
      artist: json['artist'],
      url: "https://music-api.zentradigitalsolution.my.id/api/songs/${json['ID']}/stream",
    );
  }
}