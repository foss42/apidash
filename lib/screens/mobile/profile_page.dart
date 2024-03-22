// profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
final userNameProvider = StateProvider((ref) => 'Chirag Tyagi');
final profilePictureProvider = StateProvider((ref) => 'https://i.pinimg.com/236x/b4/82/cc/b482cc66b75f9ecd3390f93bbb0393c7.jpg'); // You can replace with an Image Provider

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final profilePicture = ref.watch(profilePictureProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profilePicture),
                ),
                const SizedBox(width: 16.0),
                Text(userName, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(thickness: 1.0),
            Expanded(
              child: DefaultTabController(
                length: 6, // Adjust based on the number of tabs you want
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: 'History'),
                        Tab(text: 'Results'),
                        Tab(text: 'Collections'),
                        Tab(text: 'Folders'),
                        Tab(text: 'Saved Items'),
                        Tab(text: 'Help'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Replace with your widgets for each tab content
                          Center(child: Text('API History')),
                          Center(child: Text('Results')),
                          Center(child: Text('Collections')),
                          Center(child: Text('Folders')),
                          Center(child: Text('Saved Items')),
                          Center(child: Text('Help')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Implement logout logic (clear providers, navigate to login screen)
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
