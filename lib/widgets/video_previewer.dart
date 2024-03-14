import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPreviewer extends ConsumerStatefulWidget {
  const VideoPreviewer({Key? key}) : super(key: key);

  @override
  _VideoPreviewerState createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends ConsumerState<VideoPreviewer> {
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  @override
  void initState() {
    super.initState();

    final url = ref.read(selectedRequestModelProvider)!.url;
    player.open(Media(url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Video(controller: controller),
    );
  }
}
