import 'package:example/src/data.dart';
import 'package:flutter/material.dart';

import 'package:example/src/models.dart';

class EmojiAutocompleteOptions extends StatelessWidget {
  const EmojiAutocompleteOptions({
    Key? key,
    required this.query,
    required this.onEmojiTap,
  }) : super(key: key);

  final String query;
  final ValueSetter<Emoji> onEmojiTap;

  @override
  Widget build(BuildContext context) {
    final emojis = kEmojis.where((it) {
      final normalizedOption = it.shortName.toLowerCase();
      final normalizedQuery = query.toLowerCase();
      return normalizedOption.contains(normalizedQuery);
    });

    if (emojis.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      // color: _streamChatTheme.colorTheme.barsBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: const Color(0xFFF7F7F8),
            child: ListTile(
              dense: true,
              horizontalTitleGap: 0,
              title: Text("Emoji's matching '$query'"),
            ),
          ),
          const Divider(height: 0),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: emojis.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, i) {
                final emoji = emojis.elementAt(i);
                return ListTile(
                  dense: true,
                  leading: Text(
                    emoji.char,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(emoji.shortName),
                  onTap: () => onEmojiTap(emoji),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
