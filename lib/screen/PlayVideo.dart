import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sikhboi/screen/VideoList.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayVideo extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final String? catId;
  const PlayVideo({required this.videoId, required this.title, required this.description, this.catId, Key? key}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  static const _insets = 16.0;
  BannerAd? _bannerAd;
  late Orientation _currentOrientation;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);
  YoutubePlayerController _controller = YoutubePlayerController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    loadAd();
  }

  void loadAd() async {

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3028551801469741/7770740500',
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {

        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return Scaffold(
          body: Column(
            children: [
              player,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      IconButton(
                          onPressed: (){
                            if(widget.catId == null) {
                              Navigator.pop(context);
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoList(catId: widget.catId!,)));
                            }
                            _controller.mute();
                          },
                          icon: const Icon(Icons.arrow_back_ios)
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _bannerAd != null ?
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SafeArea(
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                      )
                          : SizedBox(),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

  }
}
