import 'package:flutter/material.dart';
import 'package:music_player_project/play_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  List<SongModel>? songs;

  Future<void> getSongs() async {
    bool haspermission = await onAudioQuery.checkAndRequest(retryRequest: true);
    if (haspermission) {
      songs = await onAudioQuery.querySongs();
      setState(() {});
    }
  }

  @override
  void initState() {
    getSongs();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 61, 61, 59),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text("Music Player Me",
                        style: TextStyle(color: Colors.white))),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: songs == null
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: songs?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayPage(
                                        song: songs![index],
                                      ),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    QueryArtworkWidget(
                                      id: songs![index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkBorder: BorderRadius.circular(10),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            songs![index].title,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(songs![index].artist ?? "",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
