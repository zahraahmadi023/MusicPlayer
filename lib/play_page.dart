import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayPage extends StatefulWidget {
  final SongModel song;
  const PlayPage({super.key, required this.song});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  AudioPlayer? audioPlayer = AudioPlayer();
  Duration? duration;
  Duration currentDuration = Duration();

  Future<void> getSong() async {
    duration = await audioPlayer
        ?.setAudioSource(AudioSource.uri(Uri.parse(widget.song.uri!)));
    audioPlayer?.positionStream.listen((event) {
      currentDuration = event;
      setState(() {});
    });
  }

  @override
  void initState() {
    getSong();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer!.stop();
    // TODO: implement dispose
    super.dispose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                  tileMode: TileMode.clamp, sigmaX: 10, sigmaY: 10),
              child: QueryArtworkWidget(
                id: widget.song.id,
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(20),
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                artworkFit: BoxFit.cover,
                keepOldArtwork: true,

                ///keep image + qhat nasheh bad pas va ply
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.4),
            ),
            Container(
              width: double.infinity,
              child: Column(children: [
                Container(
                  height: 20,
                ),
                Text(
                  widget.song.title,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.song!.artist ?? "",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 40,
                ),
                QueryArtworkWidget(
                  id: widget.song.id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(20),
                  artworkHeight: 350,
                  artworkWidth: 350,
                  keepOldArtwork: true,
                ),
                // Image.asset(
                //   'assets/img/singer2.jpg',
                //   width: MediaQuery.of(context).size.width - 100,
                //   //height: MediaQuery.of(context).size.height - 100,
                // ),
                Spacer(),
                SliderTheme(
                  data: SliderThemeData(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      trackHeight: 2),
                  child: Slider(
                    thumbColor: Colors.white,
                    value:
                        currentDuration.inSeconds / (duration?.inSeconds ?? 1),
                    activeColor: Colors.white,
                    inactiveColor: Color(0XFFA0A0A2),
                    onChanged: (value) {
                      audioPlayer!.seek(Duration(
                          seconds:
                              (value * (duration?.inSeconds ?? 1)).round()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentDuration
                            .toString()
                            .split('.')[0]
                            .padLeft(8, '0'),
                        style: TextStyle(color: Color(0XFFA0A0A2)),
                      ),
                      Text(
                        duration.toString().split('.')[0].padLeft(8, '0'),
                        style: TextStyle(color: Color(0XFFA0A0A2)),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          audioPlayer
                              ?.seek(currentDuration - Duration(seconds: 10));
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 30,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (audioPlayer!.playing) {
                          audioPlayer!.pause();
                        } else {
                          audioPlayer!.play();
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0XFF3F434C),
                        ),
                        child: Icon(
                          audioPlayer!.playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          audioPlayer
                              ?.seek(currentDuration + Duration(seconds: 10));
                        },
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 30,
                        )),
                  ],
                ),
                Container(
                  height: 40,
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
