import 'package:example/src/chat_message_list.dart';
import 'package:example/src/chat_message_text_field.dart';
import 'package:example/src/data.dart';
import 'package:example/src/options/options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          textTheme: GoogleFonts.robotoMonoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final messages = [...sampleGroupConversation];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(0xFF5B61B9),
        title: const Text(
          'Multi Trigger Autocomplete',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessageList(messages: messages)),
          MultiTriggerAutocomplete(
            optionsAlignment: OptionsAlignment.topStart,
            autocompleteTriggers: [
              AutocompleteTrigger(
                trigger: '@',
                optionsViewBuilder: (context, autocompleteQuery, controller) {
                  return MentionAutocompleteOptions(
                    query: autocompleteQuery.query,
                    onMentionUserTap: (user) {
                      final autocomplete = MultiTriggerAutocomplete.of(context);
                      return autocomplete.acceptAutocompleteOption(user.id);
                    },
                  );
                },
              ),
              AutocompleteTrigger(
                trigger: '#',
                optionsViewBuilder: (context, autocompleteQuery, controller) {
                  return HashtagAutocompleteOptions(
                    query: autocompleteQuery.query,
                    onHashtagTap: (hashtag) {
                      final autocomplete = MultiTriggerAutocomplete.of(context);
                      return autocomplete
                          .acceptAutocompleteOption(hashtag.name);
                    },
                  );
                },
              ),
              AutocompleteTrigger(
                trigger: ':',
                optionsViewBuilder: (context, autocompleteQuery, controller) {
                  return EmojiAutocompleteOptions(
                    query: autocompleteQuery.query,
                    onEmojiTap: (emoji) {
                      final autocomplete = MultiTriggerAutocomplete.of(context);
                      return autocomplete.acceptAutocompleteOption(
                        emoji.char,
                        // Passing false as we don't want the trigger [:] to
                        // get prefixed to the option in case of emoji.
                        keepTrigger: false,
                      );
                    },
                  );
                },
              ),
            ],
            fieldViewBuilder: (context, controller, focusNode) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatMessageTextField(
                  focusNode: focusNode,
                  controller: controller,
                  onSend: (message) {
                    controller.clear();
                    setState(() {
                      messages.add(message);
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
