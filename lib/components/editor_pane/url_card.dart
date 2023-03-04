import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../styles.dart';
import '../../consts.dart';

class EditorPaneRequestURLCard extends ConsumerStatefulWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  ConsumerState<EditorPaneRequestURLCard> createState() =>
      _EditorPaneRequestURLCardState();
}

class _EditorPaneRequestURLCardState
    extends ConsumerState<EditorPaneRequestURLCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    return Card(
      shape: cardShape,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 20,
        ),
        child: Row(
          children: [
            DropdownButtonHTTPMethod(),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: URLTextField(),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              height: 36,
              child: ElevatedButton(
                onPressed: () async {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .sendRequest(activeId!);
                },
                child: Row(
                  children: [
                    Text("Send"),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(size: 16, Icons.send),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownButtonHTTPMethod extends ConsumerStatefulWidget {
  const DropdownButtonHTTPMethod({
    super.key,
  });

  @override
  ConsumerState<DropdownButtonHTTPMethod> createState() =>
      _DropdownButtonHTTPMethodState();
}

class _DropdownButtonHTTPMethodState
    extends ConsumerState<DropdownButtonHTTPMethod> {
  //late HTTPVerb dropdownValue;

  @override
  void initState() {
    super.initState();
    //dropdownValue = ref
    //    .read(collectionStateNotifierProvider.notifier)
    //    .idxOfId(String id);
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    final collection = ref.read(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final method = ref.watch(
        collectionStateNotifierProvider.select((value) => value[idIdx].method));
    //final model = ref
    //    .read(collectionStateNotifierProvider.notifier)
    //    .getRequestModel(activeId!);
    return DropdownButton<HTTPVerb>(
      focusColor: Colors.white,
      //value: collection[idIdx].method,
      value: method, //model.method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
        //color: Colors.deepPurpleAccent,
      ),
      onChanged: (HTTPVerb? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, method: value);
      },
      borderRadius: BorderRadius.circular(10),
      items: HTTPVerb.values.map<DropdownMenuItem<HTTPVerb>>((HTTPVerb value) {
        return DropdownMenuItem<HTTPVerb>(
          //alignment: AlignmentDirectional.center,
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.name.toUpperCase(),
              style: TextStyle(color: getHTTPMethodColor(value)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class URLTextField extends ConsumerStatefulWidget {
  const URLTextField({
    super.key,
  });

  @override
  ConsumerState<URLTextField> createState() => _URLTextFieldState();
}

class _URLTextFieldState extends ConsumerState<URLTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    return TextFormField(
      key: Key("url-${activeId!}"),
      initialValue: ref
          .read(collectionStateNotifierProvider.notifier)
          .getRequestModel(activeId!)
          .url,
      decoration: InputDecoration(
        hintText: "Enter API endpoint like api.foss42.com/country/codes",
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, url: value);
      },
    );
  }
}
