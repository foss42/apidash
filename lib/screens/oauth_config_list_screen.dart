import 'package:apidash/screens/oauth_config_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/oauth_config_provider.dart';

class OAuthConfigListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(oauthConfigProvider);
    print('[OAuth Config] Current configs in UI: ${configs.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('OAuth Configurations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OAuthConfigScreen(),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: configs.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No configurations found.'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.width * 0.8 * 1.5,
                                    child: OAuthConfigScreen(),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Create New Configuration'),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: configs.length,
                      itemBuilder: (context, index) {
                        final config = configs[index];
                        return ListTile(
                          title: Text(config.name),
                          subtitle: Text(config.clientId),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.width * 0.8 * 1.5,
                                    child: OAuthConfigScreen(config: config),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}