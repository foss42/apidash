import 'dart:io';
import 'package:apidash/consts.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoPreviewer extends StatefulWidget {
  const VideoPreviewer({
    super.key,
    required this.videoBytes,
  });

  final Uint8List videoBytes;

  @override
  State<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _showControls = false;
  bool _isPlaying = false;
  File? _tempVideoFile;

  @override
  void initState() {
    super.initState();
    registerWithAllPlatforms();
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
  }

  void registerWithAllPlatforms() {
    try {
      fvp.registerWith();
    } catch (e) {
      debugPrint("VideoPreviewer registerWithAllPlatforms(): $e");
    }
  }

  Future<void> _initializeVideoPlayer() async {
    final tempDir = await getTemporaryDirectory();
    _tempVideoFile = File(
      '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );

    try {
      await _tempVideoFile!.writeAsBytes(widget.videoBytes);
      _videoController = VideoPlayerController.file(_tempVideoFile!);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint("VideoPreviewer _initializeVideoPlayer(): $e");
    }
  }

  void _togglePlayPause() {
    if (_videoController == null) return;
    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
      _isPlaying = false;
    } else {
      _videoController!.play();
      _isPlaying = true;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.white;
    final progressBarColors = VideoProgressColors(
      playedColor: iconColor,
      bufferedColor: iconColor.withOpacity(0.5),
      backgroundColor: iconColor.withOpacity(0.3),
    );

    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _videoController != null &&
              _videoController!.value.isInitialized) {
            return MouseRegion(
              onEnter: (_) {
                if (mounted) setState(() => _showControls = true);
              },
              onExit: (_) {
                if (mounted) setState(() => _showControls = false);
              },
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: 50.0,
                      child: VideoProgressIndicator(
                        _videoController!,
                        allowScrubbing: true,
                        padding: const EdgeInsets.all(20),
                        colors: progressBarColors,
                      ),
                    ),
                  ),
                  if (_showControls)
                    Center(
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 64,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.pause();
    _videoController?.dispose();
    if (!kIsRunningTests) {
      if (_tempVideoFile != null && _tempVideoFile!.existsSync()) {
        _tempVideoFile!.delete().catchError(
          (e) => debugPrint("VideoPreviewer dispose(): $e"),
        );
      }
    }
    super.dispose();
  }
}
