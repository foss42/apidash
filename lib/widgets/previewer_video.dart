import 'dart:io';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoPreviewer extends ConsumerStatefulWidget {
  const VideoPreviewer({
    super.key,
    required this.videoBytes,
    this.isPartOfHistory = false,
  });

  final Uint8List videoBytes;
  final bool isPartOfHistory;

  @override
  ConsumerState<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends ConsumerState<VideoPreviewer> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  late File _tempVideoFile;
  bool _showControls = false;

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
        '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}');
    try {
      await _tempVideoFile.writeAsBytes(widget.videoBytes);
      _videoController = VideoPlayerController.file(_tempVideoFile);
      await _videoController.initialize();
      if (mounted) {
        setState(() {
          _videoController.play();
          _isPlaying = true; // Sync state
          _videoController.setLooping(true);
        });
      }
    } catch (e) {
      debugPrint("VideoPreviewer _initializeVideoPlayer(): $e");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Monitor tab index to pause video when not visible
    final navRailIndex = ref.watch(navRailIndexStateProvider);
    final isVisible = widget.isPartOfHistory
        ? navRailIndex == 2 // History tab
        : navRailIndex == 0; // Requests tab

    if (!isVisible &&
        _videoController.value.isInitialized &&
        _videoController.value.isPlaying) {
      _videoController.pause();
      // We don't update _isPlaying here so that if the user returns,
      // we could potentially resume if we wanted to, or at least
      // the UI reflects that it was playing.
      // However, for this bug fix, strictly ensuring silence is key.
      // Let's update UI state to match reality.
      setState(() {
        _isPlaying = false;
      });
    }

    final iconColor = Theme.of(context).iconTheme.color;
    final progressBarColors = VideoProgressColors(
      playedColor: iconColor!,
      bufferedColor: iconColor.withValues(alpha: 0.5),
      backgroundColor: iconColor.withValues(alpha: 0.3),
    );
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_videoController.value.isInitialized) {
              return MouseRegion(
                onEnter: (_) => setState(() => _showControls = true),
                onExit: (_) => setState(() => _showControls = false),
                child: Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SizedBox(
                        height: 50.0,
                        child: VideoProgressIndicator(
                          _videoController,
                          allowScrubbing: true,
                          padding: const EdgeInsets.all(20),
                          colors: progressBarColors,
                        ),
                      ),
                    ),
                    if (_showControls)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_videoController.value.isPlaying) {
                              _videoController.pause();
                            } else {
                              _videoController.play();
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
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoController.pause();
    _videoController.dispose();
    if (!kIsRunningTests) {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          if (await _tempVideoFile.exists()) {
            await _tempVideoFile.delete();
          }
        } catch (e) {
          debugPrint("VideoPreviewer dispose(): $e");
          return;
        }
      });
    }
    super.dispose();
  }
}
