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
      url: "http://10.0.2.2:8080/api/songs/${json['ID']}/stream",
    );
  }
}