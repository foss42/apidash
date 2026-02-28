import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:json_explorer/json_explorer.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Json Explorer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Small JSON',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const _OpenJsonButton(
            title: 'ISS current location',
            url: 'http://api.open-notify.org/iss-now.json',
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          const _OpenJsonButton(
            title: 'Country List',
            url: 'https://api.foss42.com/country/codes',
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          Text(
            'Medium JSON',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const _OpenJsonButton(
            title: 'Nobel prizes country',
            url: 'http://api.nobelprize.org/v1/country.json',
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          const _OpenJsonButton(
            title: 'Australia ABC Local Stations',
            url:
                'https://data.gov.au/geoserver/abc-local-stations/wfs?request=GetFeature&typeName=ckan_d534c0e9_a9bf_487b_ac8f_b7877a09d162&outputFormat=json',
          ),
          Text(
            'Large JSON',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const _OpenJsonButton(
            title: 'Pokémon',
            url: 'https://pokeapi.co/api/v2/pokemon/?offset=0&limit=2000',
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          const _OpenJsonButton(
            title: 'Earth Meteorite Landings',
            url: 'https://data.nasa.gov/resource/y77d-th95.json',
          ),
          const _OpenJsonButton(
            title: 'Reddit r/all',
            url: 'https://www.reddit.com/r/all.json',
          ),
          Text(
            'Exploding JSON',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const _OpenJsonButton(
            title: '25MB GitHub Json',
            url:
                'https://raw.githubusercontent.com/json-iterator/test-data/master/large-file.json',
            padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
          ),
          Text(
            'More datasets at https://awesomeopensource.com/project/jdorfman/awesome-json-datasets',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class JsonExplorerPage extends StatefulWidget {
  final String jsonUrl;
  final String title;

  const JsonExplorerPage({
    Key? key,
    required this.jsonUrl,
    required this.title,
  }) : super(key: key);

  @override
  _JsonExplorerPageState createState() => _JsonExplorerPageState();
}

class _JsonExplorerPageState extends State<JsonExplorerPage> {
  final searchController = TextEditingController();
  final itemScrollController = ItemScrollController();
  final JsonExplorerStore store = JsonExplorerStore();

  @override
  void initState() {
    _loadJsonDataFrom(widget.jsonUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ChangeNotifierProvider.value(
          value: store,
          child: Consumer<JsonExplorerStore>(
            builder: (context, state, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,

                        /// Delegates the search to [JsonExplorerStore] when
                        /// the text field changes.
                        onChanged: (term) => state.search(term),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (state.searchResults.isNotEmpty)
                      Text(_searchFocusText()),
                    if (state.searchResults.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          store.focusPreviousSearchResult();
                          _scrollToSearchMatch();
                        },
                        icon: const Icon(Icons.arrow_drop_up),
                      ),
                    if (state.searchResults.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          store.focusNextSearchResult();
                          _scrollToSearchMatch();
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed:
                          state.areAllExpanded() ? null : state.expandAll,
                      child: const Text('Expand All'),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    TextButton(
                      onPressed:
                          state.areAllCollapsed() ? null : state.collapseAll,
                      child: const Text('Collapse All'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Expanded(
                  child: JsonExplorer(
                    nodes: state.displayNodes,
                    itemScrollController: itemScrollController,
                    itemSpacing: 4,
                    maxRootNodeWidth: 200,

                    /// Builds a widget after each root node displaying the
                    /// number of children nodes that it has. Displays `{x}`
                    /// if it is a class or `[x]` in case of arrays.
                    rootInformationBuilder: (context, node) => DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color(0x80E1E1E1),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Text(
                          node.isClass
                              ? '{${node.childrenCount}}'
                              : '[${node.childrenCount}]',
                          style: GoogleFonts.inconsolata(
                            fontSize: 12,
                            color: const Color(0xFF6F6F6F),
                          ),
                        ),
                      ),
                    ),

                    /// Build an animated collapse/expand indicator. Implicitly
                    /// animates the indicator when
                    /// [NodeViewModelState.isCollapsed] changes.
                    collapsableToggleBuilder: (context, node) =>
                        AnimatedRotation(
                      turns: node.isCollapsed ? -0.25 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.arrow_drop_down),
                    ),

                    /// Builds a trailing widget that copies the node key: value
                    ///
                    /// Uses [NodeViewModelState.isFocused] to display the
                    /// widget only in focused widgets.
                    trailingBuilder: (context, node) => node.isFocused
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(maxHeight: 18),
                            icon: const Icon(
                              Icons.copy,
                              size: 18,
                            ),
                            onPressed: () => _printNode(node),
                          )
                        : const SizedBox(),

                    /// Creates a custom format for classes and array names.
                    rootNameFormatter: (dynamic name) => '$name',

                    /// Dynamically changes the property value style and
                    /// interaction when an URL is detected.
                    valueStyleBuilder: (dynamic value, style) {
                      final isUrl = _valueIsUrl(value);
                      return PropertyOverrides(
                        style: isUrl
                            ? style.copyWith(
                                decoration: TextDecoration.underline,
                              )
                            : style,
                        onTap: isUrl ? () => _launchUrl(value as String) : null,
                      );
                    },

                    /// Theme definitions of the json explorer
                    theme: JsonExplorerTheme(
                      rootKeyTextStyle: GoogleFonts.inconsolata(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      propertyKeyTextStyle: GoogleFonts.inconsolata(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      keySearchHighlightTextStyle: GoogleFonts.inconsolata(
                        color: Colors.black,
                        backgroundColor: const Color(0xFFFFEDAD),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      focusedKeySearchHighlightTextStyle:
                          GoogleFonts.inconsolata(
                        color: Colors.black,
                        backgroundColor: const Color(0xFFF29D0B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      valueTextStyle: GoogleFonts.inconsolata(
                        color: const Color(0xFFCA442C),
                        fontSize: 16,
                      ),
                      valueSearchHighlightTextStyle: GoogleFonts.inconsolata(
                        color: const Color(0xFFCA442C),
                        backgroundColor: const Color(0xFFFFEDAD),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      focusedValueSearchHighlightTextStyle:
                          GoogleFonts.inconsolata(
                        color: Colors.black,
                        backgroundColor: const Color(0xFFF29D0B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      indentationLineColor: const Color(0xFFE1E1E1),
                      highlightColor: const Color(0xFFF1F1F1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _searchFocusText() =>
      '${store.focusedSearchResultIndex + 1} of ${store.searchResults.length}';

  Future _loadJsonDataFrom(String url) async {
    debugPrint('Calling Json API');
    final data = await http.read(Uri.parse(url));
    debugPrint('Done!');
    final dynamic decoded = json.decode(data);
    store.buildNodes(decoded, areAllCollapsed: true);
  }

  void _printNode(NodeViewModelState node) {
    if (node.isRoot) {
      final value = node.isClass ? 'class' : 'array';
      debugPrint('${node.key}: $value');
      return;
    }
    debugPrint('${node.key}: ${node.value}');
  }

  void _scrollToSearchMatch() {
    final index = store.displayNodes.indexOf(store.focusedSearchResult.node);
    if (index != -1) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  bool _valueIsUrl(dynamic value) {
    if (value is String) {
      return Uri.tryParse(value)?.hasAbsolutePath ?? false;
    }
    return false;
  }

  Future _launchUrl(String url) {
    return launchUrlString(url);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

/// A button that navigates to the data explorer page on pressed.
class _OpenJsonButton extends StatelessWidget {
  final String url;
  final String title;
  final EdgeInsets padding;

  const _OpenJsonButton({
    Key? key,
    required this.url,
    required this.title,
    this.padding = const EdgeInsets.only(bottom: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: ElevatedButton(
          child: Text(title),
          onPressed: () => Navigator.of(context).push<MaterialPageRoute>(
            MaterialPageRoute(
              builder: (ctx) => JsonExplorerPage(
                jsonUrl: url,
                title: title,
              ),
            ),
          ),
        ),
      );
}
