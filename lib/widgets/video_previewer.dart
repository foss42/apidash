import 'dart:io';
import 'dart:typed_data';
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
  bool _isPlaying = false;
  File? _tempVideoFile;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    registerWithAllPlatforms();
    _initializeVideoPlayer();
  }

  void registerWithAllPlatforms() {
    try {
      fvp.registerWith();
    } catch (e) {
      // pass
    }
  }

  void _initializeVideoPlayer() async {
    final tempDir = await getTemporaryDirectory();
    _tempVideoFile = File(
        '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}');
    try {
      await _tempVideoFile?.writeAsBytes(widget.videoBytes);
      _videoController = VideoPlayerController.file(_tempVideoFile!)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _videoController!.play();
              _videoController!.setLooping(true);
            });
          }
        });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    final progressBarColors = VideoProgressColors(
      playedColor: iconColor!,
      bufferedColor: iconColor.withOpacity(0.5),
      backgroundColor: iconColor.withOpacity(0.3),
    );
    return Scaffold(
      body: MouseRegion(
        onEnter: (_) => setState(() => _showControls = true),
        onExit: (_) => setState(() => _showControls = false),
        child: Stack(
          children: [
            Center(
              child: _videoController?.value.isInitialized == true
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : const CircularProgressIndicator(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _videoController?.value.isInitialized == true
                  ? SizedBox(
                      height: 50.0,
                      child: VideoProgressIndicator(
                        _videoController!,
                        allowScrubbing: true,
                        padding: const EdgeInsets.all(20),
                        colors: progressBarColors,
                      ),
                    )
                  : Container(height: 0),
            ),
            if (_showControls)
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Icon(
                      _isPlaying ? Icons.play_arrow : Icons.pause,
                      size: 64,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.pause();
    _videoController?.dispose();
    if (!kIsRunningTests) {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          if (_tempVideoFile != null) {
            await _tempVideoFile!.delete();
          }
        } catch (e) {
          return;
        }
      });
    }
    super.dispose();
  }
}
