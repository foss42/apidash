import 'dart:io';
import 'package:apidash/consts.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'error_message.dart';

bool shouldRegisterFvpVideoBackend({
  required bool isWeb,
  required bool isLinux,
  required bool isWindows,
}) {
  return !isWeb && (isLinux || isWindows);
}

String getVideoTempFileSuffix(String? extension) {
  if (extension == null || extension.isEmpty) {
    return '';
  }
  return extension.startsWith('.') ? extension : '.$extension';
}

class VideoPreviewer extends StatefulWidget {
  const VideoPreviewer({
    super.key,
    required this.videoBytes,
    this.videoFileExtension,
  });

  final Uint8List videoBytes;
  final String? videoFileExtension;

  @override
  State<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {
  VideoPlayerController? _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  File? _tempVideoFile;
  Object? _initializationError;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    registerVideoPlayerBackend();
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
  }

  void registerVideoPlayerBackend() {
    if (!shouldRegisterFvpVideoBackend(
      isWeb: kIsWeb,
      isLinux: kIsLinux,
      isWindows: kIsWindows,
    )) {
      return;
    }
    try {
      fvp.registerWith();
    } catch (e) {
      debugPrint("VideoPreviewer registerVideoPlayerBackend(): $e");
    }
  }

  Future<void> _initializeVideoPlayer() async {
    final tempDir = await getTemporaryDirectory();
    final fileSuffix = getVideoTempFileSuffix(widget.videoFileExtension);
    final tempVideoFile = File(
      '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}$fileSuffix',
    );
    VideoPlayerController? videoController;
    try {
      await tempVideoFile.writeAsBytes(widget.videoBytes, flush: true);
      videoController = VideoPlayerController.file(tempVideoFile);
      await videoController.initialize();
      await videoController.setLooping(false);
      await videoController.play();
      if (!mounted) {
        await videoController.dispose();
        if (tempVideoFile.existsSync()) {
          await tempVideoFile.delete();
        }
        return;
      }
      setState(() {
        _initializationError = null;
        _tempVideoFile = tempVideoFile;
        _videoController = videoController;
      });
    } catch (e) {
      if (videoController != null) {
        await videoController.dispose();
      }
      if (tempVideoFile.existsSync()) {
        await tempVideoFile.delete();
      }
      if (mounted) {
        setState(() {
          _initializationError = e;
        });
      } else {
        _initializationError = e;
      }
      debugPrint("VideoPreviewer _initializeVideoPlayer(): $e");
      return;
    }
  }

  Widget _buildErrorWidget() {
    final errorTemplate = jj.Template(kMimeTypeRaiseIssue);
    return ErrorMessage(
      message: errorTemplate.render({
        'showRaw': false,
        'showContentType': false,
        'type': 'video',
      }),
    );
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
          final videoController = _videoController;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_initializationError != null ||
              videoController == null ||
              !videoController.value.isInitialized) {
            return _buildErrorWidget();
          }
          return MouseRegion(
            onEnter: (_) => setState(() => _showControls = true),
            onExit: (_) => setState(() => _showControls = false),
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: 50.0,
                    child: VideoProgressIndicator(
                      videoController,
                      allowScrubbing: true,
                      padding: const EdgeInsets.all(20),
                      colors: progressBarColors,
                    ),
                  ),
                ),
                if (_showControls)
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (videoController.value.isPlaying) {
                          await videoController.pause();
                        } else {
                          await videoController.play();
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          videoController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 64,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    final videoController = _videoController;
    final tempVideoFile = _tempVideoFile;
    if (videoController != null) {
      videoController.pause();
      videoController.dispose();
    }
    if (!kIsRunningTests && tempVideoFile != null) {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          if (await tempVideoFile.exists()) {
            await tempVideoFile.delete();
          }
        } catch (e) {
          debugPrint("VideoPreviewer dispose(): $e");
        }
      });
    }
    super.dispose();
  }
}
