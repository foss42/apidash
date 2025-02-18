import 'package:example/src/data.dart';
import 'package:flutter/material.dart';

import 'package:example/src/models.dart';

class MentionAutocompleteOptions extends StatelessWidget {
  const MentionAutocompleteOptions({
    Key? key,
    required this.query,
    required this.onMentionUserTap,
  }) : super(key: key);

  final String query;
  final ValueSetter<User> onMentionUserTap;

  @override
  Widget build(BuildContext context) {
    final users = kUsers.where((it) {
      final normalizedId = it.id.toLowerCase();
      final normalizedName = it.name.toLowerCase();
      final normalizedQuery = query.toLowerCase();
      return normalizedId.contains(normalizedQuery) ||
          normalizedName.contains(normalizedQuery);
    });

    if (users.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
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
              title: Text("Users matching '$query'"),
            ),
          ),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: users.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, i) {
                final user = users.elementAt(i);
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  title: Text(user.name),
                  subtitle: Text('@${user.id}'),
                  onTap: () => onMentionUserTap(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
