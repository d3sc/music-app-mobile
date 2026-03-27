import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/music_repository.dart';
import '../application/music_player_service.dart';
import 'music_page.dart';
import 'upload_music_page.dart';
import 'widget/mini_player.dart';
import '../../../domain/music.dart';

class MusicCollectionPage extends StatefulWidget {
  const MusicCollectionPage({super.key});

  @override
  State<MusicCollectionPage> createState() =>
      _MusicCollectionPageState();
}

class _MusicCollectionPageState extends State<MusicCollectionPage> {
  late Future<List<Music>> _futureMusic;
  final repository = MusicRepository();

  @override
  void initState() {
    super.initState();
    _futureMusic = repository.getAllMusic();
  }

  void _refresh() {
    setState(() {
      _futureMusic = repository.getAllMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicService =
        Provider.of<MusicPlayerService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Music List")),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UploadMusicPage(),
              ),
            );

            // refresh page
            _refresh(); 
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),

      body: Stack(
        children: [
          FutureBuilder<List<Music>>(
            future: _futureMusic,
            builder: (context, snapshot) {

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }

              final musics = snapshot.data ?? [];

              WidgetsBinding.instance.addPostFrameCallback((_) {
                musicService.setPlaylist(musics);
              });

              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                },

                child: ListView.builder(
                  padding:
                      const EdgeInsets.only(bottom: 130),
                  itemCount: musics.length,
                  itemBuilder: (context, index) {
                    final music = musics[index];

                    return Consumer<MusicPlayerService>(
                      builder: (context, player, _) {

                        final isCurrent =
                            player.currentMusic?.id ==
                                music.id;

                        final isPlaying =
                            isCurrent && player.isPlaying;

                        return Card(
                          child: ListTile(
                            onTap: () {
                              if (player.currentMusic?.id !=
                                  music.id) {
                                player.play(music);
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const MusicPlayerPage(),
                                ),
                              );
                            },

                            title: Text(music.title),
                            subtitle: Text(music.artist),

                            trailing: GestureDetector(
                              onTap: () async {
                                if (isCurrent &&
                                    isPlaying) {
                                  await player.pause();
                                } else {
                                  await player.play(music);
                                }
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),

          const Align(
            alignment: Alignment.bottomRight,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}