import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'custom_list_tile.dart';
import 'list.dart';

const kBackColor = Color(0xff393E46);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  String currentTitle = '';
  String currentSinger = '';
  String currentCover = '';
  IconData btnIcon = Icons.play_circle_fill_rounded;

  //Player
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong = '';
  Duration duration = const Duration();
  Duration position = const Duration();

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      await audioPlayer.play(UrlSource(url), mode: PlayerMode.lowLatency);
           // will immediately start playing
      if (isPlaying) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      await audioPlayer.play(UrlSource(url), mode: PlayerMode.lowLatency);
      if (isPlaying) {
        setState(() {
          isPlaying = true;
          btnIcon = Icons.pause_circle_filled_rounded;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: AppBar(
        backgroundColor: kBackColor,
        elevation: 0,
        title: const Text(
          'Flutteriha Music',
          style: TextStyle(color: Color(0xffEEEEEE)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CustomListTile(
                  title: musicList[index]['title'],
                  singer: musicList[index]['singer'],
                  cover: musicList[index]['coverUrl'],
                  onTap: () {
                    playMusic(musicList[index]['url']);
                    setState(() {
                      currentTitle = musicList[index]['title'];
                      currentSinger = musicList[index]['singer'];
                      currentCover = musicList[index]['coverUrl'];
                      btnIcon = Icons.pause_circle_filled_rounded;
                    });
                  }),
              itemCount: musicList.length,
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Color(0xff222831), boxShadow: [
              BoxShadow(
                color: Color(0xff222831),
                blurRadius: 8.0,
              )
            ]),
            child: Column(
              children: [
                Slider.adaptive(
                    value: position.inSeconds.toDouble(),
                    min: -3,
                    max: duration.inSeconds.toDouble() + 3,
                    onChanged: (value) {}),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 17.0,
                    bottom: 8.0,
                    right: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                image: DecorationImage(
                                  image: NetworkImage(currentCover),
                                )),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTitle,
                                style: const TextStyle(
                                    color: Color(0xffeeeeee),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 0.0,
                              ),
                              Text(
                                currentSinger,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10.0),
                              )
                            ],
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (isPlaying) {
                            audioPlayer.pause();
                            setState(() {
                              btnIcon = Icons.play_circle_filled_rounded;
                              isPlaying = false;
                            });
                          } else {
                            audioPlayer.resume();
                            setState(() {
                              btnIcon = Icons.pause_circle_filled_rounded;
                              isPlaying = true;
                            });
                          }
                        },
                        icon: Icon(
                          btnIcon,
                        ),
                        color: Colors.white70,
                        iconSize: 60,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
