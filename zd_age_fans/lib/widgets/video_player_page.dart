import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class ChewieVideoPage extends StatefulWidget {
  const ChewieVideoPage({super.key, this.videoUrl = ''});
  final String videoUrl;

  @override
  State<ChewieVideoPage> createState() => _ChewieVideoPageState();
}

class _ChewieVideoPageState extends State<ChewieVideoPage> {
  late BetterPlayerController _betterPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  final _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: _aspectRatio,
      ),
    );
    _initializeVideoPlayerFuture =
        _betterPlayerController.setupDataSource(betterPlayerDataSource);
  }

  /*销毁*/
  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          '在线视频播放',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: AspectRatio(
        aspectRatio: _aspectRatio,
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return BetterPlayer(controller: _betterPlayerController);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
