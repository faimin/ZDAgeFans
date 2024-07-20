import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieVideoPage extends StatefulWidget {
  const ChewieVideoPage({super.key, this.videoUrl = ''});
  final String videoUrl;

  @override
  State<ChewieVideoPage> createState() => _ChewieVideoPageState();
}

class _ChewieVideoPageState extends State<ChewieVideoPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  // late Future<void> _initializeVideoPlayerFuture;

  final _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    // _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _aspectRatio, //视频宽高比
      autoPlay: true,
      fullScreenByDefault: false,
      subtitle: Subtitles([
        Subtitle(
          index: 0,
          start: Duration.zero,
          end: const Duration(seconds: 1),
          text: '加载中...',
        ),
      ]),
    );
  }

  /*销毁*/
  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('在线视频播放'),
      ),
      body: Center(
        child: SizedBox(
          child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: Chewie(
              controller: _chewieController,
            ),
          ),
        ),
      ),
    );
  }
}
