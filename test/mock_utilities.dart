import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

class MockVideoPlayerPlatform extends VideoPlayerPlatform {
  final Completer<bool> initialized = Completer<bool>();
  final List<String> calls = <String>[];
  final List<DataSource> dataSources = <DataSource>[];
  final Map<int, StreamController<VideoEvent>> streams = <int, StreamController<VideoEvent>>{};
  final bool forceInitError;
  int nextTextureId = 0;
  MockVideoPlayerPlatform({
    this.forceInitError = false,
  });

  @override
  Future<int?> create(DataSource dataSource) async {
    calls.add('create');
    final StreamController<VideoEvent> stream = StreamController<VideoEvent>();
    streams[nextTextureId] = stream;
    if (forceInitError) {
      stream.addError(
        PlatformException(
          code: 'VideoError',
          message: 'Video player had error XYZ',
        ),
      );
    } else {
      stream.add(
        VideoEvent(
          eventType: VideoEventType.initialized,
          size: const Size(100, 100),
          duration: const Duration(seconds: 1),
        ),
      );
    }
    dataSources.add(dataSource);
    return nextTextureId++;
  }

  @override
  Future<void> dispose(int textureId) async {
    calls.add('dispose');
  }

  @override
  Future<void> init() async {
    calls.add('init');
    initialized.complete(true);
  }

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) {
    return streams[textureId]!.stream;
  }

  @override
  Future<void> play(int textureId) async {
    calls.add('play');
    final StreamController<VideoEvent> stream = streams[textureId]!;
    stream.add(VideoEvent(eventType: VideoEventType.isPlayingStateUpdate, isPlaying: true));
  }

  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) async {
    calls.add('setPlaybackSpeed');
    final StreamController<VideoEvent> stream = streams[textureId]!;
    stream.add(VideoEvent(
      eventType: VideoEventType.unknown,
    ));
  }

  @override
  Widget buildView(int textureId) {
    calls.add('buildView');
    return Scaffold();
  }

  @override
  Future<void> pause(int textureId) async {
    calls.add('pause');
    final StreamController<VideoEvent> stream = streams[textureId]!;
    stream.add(VideoEvent(
      eventType: VideoEventType.isPlayingStateUpdate,
      isPlaying: false,
    ));
  }

  @override
  Future<void> setVolume(int textureId, double volume) async {
    calls.add('setVolume');
  }

  @override
  Future<void> setLooping(int textureId, bool looping) async {
    calls.add('setLooping');
  }
}
