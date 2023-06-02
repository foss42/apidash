import 'dart:typed_data';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

typedef AudioErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

// Uint8List AudioSource for just_audio
class Uint8AudioSource extends StreamAudioSource {
  Uint8AudioSource(this.bytes, {this.type = 'audio', this.subtype = 'mpeg'});

  final List<int> bytes;
  final String? type;
  final String? subtype;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: '$type/$subtype',
    );
  }
}

class Uint8AudioPlayer extends StatefulWidget {
  /// Creates a widget for playing audio obtained from a [Uint8List].
  const Uint8AudioPlayer({
    super.key,
    required this.bytes,
    this.type,
    this.subtype,
    required this.errorBuilder,
  });

  final Uint8List bytes;
  final String? type;
  final String? subtype;
  final AudioErrorWidgetBuilder errorBuilder;

  @override
  State<Uint8AudioPlayer> createState() => _Uint8AudioPlayerState();
}

class _Uint8AudioPlayerState extends State<Uint8AudioPlayer> {
  final player = AudioPlayer();

  @override
  void initState() {
    player.setAudioSource(Uint8AudioSource(widget.bytes,
        type: widget.type, subtype: widget.subtype));
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorBuilder(
              context, snapshot.error!, snapshot.stackTrace);
        } else {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          if (processingState == ProcessingState.ready ||
              processingState == ProcessingState.completed ||
              processingState == ProcessingState.buffering) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Audio Player
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Duration Position Builder (time elapsed)
                    _buildDuration(
                      player.positionStream,
                      maxDuration: player.duration,
                    ),

                    // Slider to view & change Duration Position
                    _buildPositionBar(
                      player.positionStream,
                      maxDuration: player.duration,
                      onChanged: (value) =>
                          player.seek(Duration(seconds: value.toInt())),
                    ),

                    // Total Duration
                    Text(
                      audioPosition(player.duration),
                      style: TextStyle(fontFamily: kCodeStyle.fontFamily),
                    ),
                  ],
                ),

                // Audio Player Controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Play/Pause Button
                    _buildPlayButton(
                      player.playingStream,
                      play: player.play,
                      pause: player.pause,
                      restart: () => player.seek(Duration.zero),
                      completed: processingState == ProcessingState.completed,
                    ),

                    // Mute/UnMute button
                    _buildVolumeButton(
                      player.volumeStream,
                      mute: () => player.setVolume(0),
                      unmute: () => player.setVolume(1),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  StreamBuilder<bool> _buildPlayButton(
    Stream<bool> stream, {
    VoidCallback? play,
    VoidCallback? pause,
    VoidCallback? restart,
    required bool completed,
  }) {
    return StreamBuilder<bool>(
      stream: stream,
      builder: (context, snapshot) {
        final playing = snapshot.data;
        if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: play,
          );
        } else if (completed) {
          return IconButton(
            icon: const Icon(Icons.replay),
            onPressed: restart,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.pause),
            onPressed: pause,
          );
        }
      },
    );
  }

  StreamBuilder<Duration> _buildDuration(
    Stream<Duration> stream, {
    Duration? maxDuration,
  }) {
    return StreamBuilder<Duration>(
      stream: stream,
      builder: (context, snapshot) {
        final position = snapshot.data;
        return Text(
          audioPosition(position),
          style: TextStyle(fontFamily: kCodeStyle.fontFamily),
        );
      },
    );
  }

  StreamBuilder<Duration> _buildPositionBar(
    Stream<Duration> stream, {
    Duration? maxDuration,
    ValueChanged<double>? onChanged,
  }) {
    return StreamBuilder<Duration>(
      stream: stream,
      builder: (context, snapshot) {
        return SizedBox(
          width: kSliderWidth,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const RectangularSliderTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: snapshot.data?.inSeconds.toDouble() ?? 0,
              max: maxDuration?.inSeconds.toDouble() ?? 0,
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }

  StreamBuilder<double> _buildVolumeButton(Stream<double> stream,
      {VoidCallback? mute, VoidCallback? unmute}) {
    return StreamBuilder<double>(
      stream: stream,
      builder: (context, snapshot) {
        return snapshot.data == 0
            ? IconButton(icon: const Icon(Icons.volume_off), onPressed: unmute)
            : IconButton(icon: const Icon(Icons.volume_up), onPressed: mute);
      },
    );
  }
}
