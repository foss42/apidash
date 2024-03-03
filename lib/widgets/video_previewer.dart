import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:fvp/fvp.dart' as fvp;    

class VideoPreviewer extends StatefulWidget {
  const VideoPreviewer({
    super.key,
    required this.videoUrl,
  });

  final dynamic videoUrl;

  @override
  State<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    register();
    Uri uri = Uri.parse(widget.videoUrl);
    _videoController = VideoPlayerController.networkUrl(
      uri,
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
    );
  }
  
  void register() {
    try {
      fvp.registerWith();
    } catch (e) {
      // pass
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
