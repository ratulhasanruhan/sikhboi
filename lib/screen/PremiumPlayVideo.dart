import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PremiumPlayVideo extends StatefulWidget {
  String videoId;
  String link;
  String name;
  PremiumPlayVideo({required this.videoId, required this.link, required this.name, Key? key}) : super(key: key);

  @override
  State<PremiumPlayVideo> createState() => _PremiumPlayVideoState();
}

class _PremiumPlayVideoState extends State<PremiumPlayVideo> {

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: widget.videoId,
              flags: YoutubePlayerFlags(
                autoPlay: true,
              ),
            ),
        ),
        builder: (context, player) {
          return Scaffold(
            body: Column(
              children: [
                player,
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios)
                    ),
                    Flexible(
                      child: Text(
                      widget.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        'Important Links',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: ()async{
                            await launchUrl(Uri.parse(widget.link),mode: LaunchMode.externalApplication);
                          },
                          icon: const Icon(Icons.file_present)
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
