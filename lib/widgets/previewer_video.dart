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
    this.autoPlay = true,
  });

  final Uint8List videoBytes;
  /// Whether to start playback automatically once the controller is ready.
  /// Pass [false] for history/read-only contexts where the user should
  /// explicitly press play.
  final bool autoPlay;

  @override
  State<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  late File _tempVideoFile;
  bool _showControls = false;
  // Whether the controller is ready for playback operations.
  bool _isControllerReady = false;
  // Tracks the last known tab-visibility from TickerMode. Kept as a plain
  // field so it can safely be read from async callbacks and setState bodies,
  // where calling TickerMode.valuesOf(context) directly is not allowed.
  bool _isCurrentlyVisible = true;
  // Tracks if the video was playing when the tab was hidden, so we can
  // resume it when the tab becomes visible again.
  bool _wasPlayingBeforeHidden = false;

  @override
  void initState() {
    super.initState();
    registerWithAllPlatforms();
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
  }

  /// Called whenever an [InheritedWidget] dependency (including [TickerMode])
  /// changes. [IndexedStack] uses [Offstage] which wraps hidden children with
  /// [TickerMode(enabled: false)]. We use this to pause/resume playback
  /// automatically when the user switches tabs.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Always read TickerMode first so this State registers as a dependent and
    // didChangeDependencies is called again whenever visibility changes — even
    // if the controller is not ready yet.
    final isVisible = TickerMode.valuesOf(context).enabled;
    _isCurrentlyVisible = isVisible;
    if (!_isControllerReady) return;
    if (!isVisible) {
      if (_videoController.value.isPlaying) {
        _wasPlayingBeforeHidden = true;
        _videoController.setVolume(0);
        _videoController.pause();
      }
    } else if (_wasPlayingBeforeHidden) {
      _wasPlayingBeforeHidden = false;
      _videoController.setVolume(1.0);
      _videoController.play();
    }
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
      _isControllerReady = true;
      if (mounted) {
        setState(() {
          // Only auto-play when both conditions hold:
          //   1. autoPlay is enabled (false for history, true for requests)
          //   2. the hosting tab is currently visible
          // _isCurrentlyVisible is maintained by didChangeDependencies; reading
          // it here is safe (TickerMode.valuesOf must NOT be called inside a
          // setState callback — only in build/didChangeDependencies).
          if (widget.autoPlay && _isCurrentlyVisible) {
            _videoController.play();
          }
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
                              _videoController.setVolume(0);
                              _videoController.pause();
                            } else {
                              _videoController.setVolume(1.0);
                              _videoController.play();
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: ValueListenableBuilder<VideoPlayerValue>(
                              valueListenable: _videoController,
                              builder: (context, value, _) => Icon(
                                value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 64,
                                color: iconColor,
                              ),
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
    _videoController.setVolume(0);
    _videoController.pause();
    _videoController.dispose();
    if (!kIsRunningTests) {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          await _tempVideoFile.delete();
        } catch (e) {
          debugPrint("VideoPreviewer dispose(): $e");
          return;
        }
      });
    }
    super.dispose();
  }
}
