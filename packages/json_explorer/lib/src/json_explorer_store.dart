import 'dart:collection';

import 'package:flutter/widgets.dart';

/// A view model state that represents a single node item in a json object tree.
/// A decoded json object can be converted to a [NodeViewModelState] by calling
/// the [buildViewModelNodes] method.
///
/// A node item can be eiter a class root, an array or a single
/// class/array field.
///
///
/// The string [key] is the same as the json key, unless this node is an element
/// if an array, then its key is its index in the array.
///
/// The node [value] behaviour depends on what this node represents, if it is
/// a property (from json: "key": "value"), then the value is the actual
/// property value, one of [num], [String], [bool], [Null]. Since this node
/// represents a single property, both [isClass] and [isArray] are false.
///
/// If this node represents a class, [value] contains a
/// [Map<String, NodeViewModelState>] with this node's children. In this case
/// [isClass] is true.
///
/// If this node represents an array, [value] contains a
/// [List<NodeViewModelState>] with this node's children. In this case
/// [isArray] is true.
///
/// See also:
/// * [buildViewModelNodes]
/// * [flatten]
class NodeViewModelState extends ChangeNotifier {
  /// This attribute name.
  final String key;

  /// How deep in the tree this node is.
  final int treeDepth;

  /// Flags if this node is a class, if [true], then [value] is as
  /// Map<String, NodeViewModelState>.
  final bool isClass;

  /// Flags if this node is an array, if [true], then [value] is a
  /// [List<NodeViewModelState>].
  final bool isArray;

  bool _isHighlighted = false;
  bool _isFocused = false;
  bool _isCollapsed;

  NodeViewModelState? _parent;

  /// A reference to the closest node above this one.
  NodeViewModelState? get parent => _parent;

  dynamic _value;

  /// Updates the [value] of this node.
  @visibleForTesting
  set value(dynamic value) {
    _value = value;
  }

  /// This attribute value, it may be one of the following:
  /// [num], [String], [bool], [Null], [Map<String, NodeViewModelState>] or
  /// [List<NodeViewModelState>].
  dynamic get value => _value;

  late int childrenCount = () {
    final dynamic currentValue = value;

    if (currentValue is Map<String, dynamic>) {
      return currentValue.keys.length;
    }

    if (currentValue is List) {
      return currentValue.length;
    }

    return 0;
  }();

  NodeViewModelState._({
    required this.treeDepth,
    required this.key,
    this.isClass = false,
    this.isArray = false,
    dynamic value,
    bool isCollapsed = false,
    NodeViewModelState? parent,
  })  : _isCollapsed = isCollapsed,
        _parent = parent,
        _value = value;

  /// Build a [NodeViewModelState] as a property.
  /// A property is a single attribute in the json, can be of a type
  /// [num], [String], [bool] or [Null].
  ///
  /// Properties always return [false] when calling [isClass], [isArray]
  /// and [isRoot]
  factory NodeViewModelState.fromProperty({
    required int treeDepth,
    required String key,
    required dynamic value,
    required NodeViewModelState? parent,
  }) =>
      NodeViewModelState._(
        key: key,
        value: value,
        treeDepth: treeDepth,
        parent: parent,
      );

  /// Build a [NodeViewModelState] as a class.
  /// A class is a JSON node containing a whole class, a class can have
  /// multiple children properties, classes or arrays.
  /// Its value is always a [Map<String, NodeViewModelState>] containing the
  /// children information.
  ///
  /// Classes always return [true] when calling [isClass] and [isRoot].
  factory NodeViewModelState.fromClass({
    required int treeDepth,
    required String key,
    required NodeViewModelState? parent,
  }) =>
      NodeViewModelState._(
        isClass: true,
        key: key,
        treeDepth: treeDepth,
        parent: parent,
      );

  /// Build a [NodeViewModelState] as an array.
  /// An array is a JSON node containing an array of objects, each element
  /// inside the array is represented by another [NodeViewModelState]. Thus
  /// it can be values or classes.
  /// Its value is always a [List<NodeViewModelState>] containing the
  /// children information.
  ///
  /// Arrays always return [true] when calling [isArray] and [isRoot].
  factory NodeViewModelState.fromArray({
    required int treeDepth,
    required String key,
    required NodeViewModelState? parent,
  }) =>
      NodeViewModelState._(
        isArray: true,
        key: key,
        treeDepth: treeDepth,
        parent: parent,
      );

  /// Returns [true] if this node is highlighted.
  ///
  /// This is a mutable property, [notifyListeners] is called to notify all
  ///  registered listeners.
  bool get isHighlighted => _isHighlighted;

  /// Returns [true] if this node is focused.
  ///
  /// This is a mutable property, [notifyListeners] is called to notify all
  ///  registered listeners.
  bool get isFocused => _isFocused;

  /// Returns [true] if this node is collapsed.
  ///
  /// This is a mutable property, [notifyListeners] is called to notify all
  /// registered listeners.
  bool get isCollapsed => _isCollapsed;

  /// Returns [true] if this is a root node.
  ///
  /// A root node is a node that contains multiple children. A class or an
  /// array.
  bool get isRoot => isClass || isArray;

  /// Returns a list of this node's children.
  Iterable<NodeViewModelState> get children {
    if (isClass) {
      return (value as Map<String, NodeViewModelState>).values;
    } else if (isArray) {
      return value as List<NodeViewModelState>;
    }
    return [];
  }

  /// Sets the highlight property of this node and all of its children.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  void highlight({bool isHighlighted = true}) {
    _isHighlighted = isHighlighted;
    for (final children in children) {
      children.highlight(isHighlighted: isHighlighted);
    }
    notifyListeners();
  }

  /// Sets the focus property of this node.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  void focus({bool isFocused = true}) {
    _isFocused = isFocused;
    notifyListeners();
  }

  /// Sets the [isCollapsed] property to [false].
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  void collapse() {
    _isCollapsed = true;
    notifyListeners();
  }

  /// Sets the [isCollapsed] property to [true].
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  void expand() {
    _isCollapsed = false;
    notifyListeners();
  }
}

/// Builds [NodeViewModelState] nodes based on a decoded json object.
///
/// The return [Map<String, NodeViewModelState>] has the same structure as
/// the decoded [object], except that every class, array and property is now
/// a [NodeViewModelState].
@visibleForTesting
Map<String, NodeViewModelState> buildViewModelNodes(dynamic object) {
  if (object is Map<String, dynamic>) {
    return _buildClassNodes(object: object);
  }
  return _buildClassNodes(object: <String, dynamic>{'data': object});
}

Map<String, NodeViewModelState> _buildClassNodes({
  required Map<String, dynamic> object,
  int treeDepth = 0,
  NodeViewModelState? parent,
}) {
  final map = <String, NodeViewModelState>{};
  object.forEach((key, dynamic value) {
    if (value is Map<String, dynamic>) {
      final classNode = NodeViewModelState.fromClass(
        treeDepth: treeDepth,
        key: key,
        parent: parent,
      );

      final children = _buildClassNodes(
        object: value,
        treeDepth: treeDepth + 1,
        parent: classNode,
      );

      classNode.value = children;

      map[key] = classNode;
    } else if (value is List) {
      final arrayNode = NodeViewModelState.fromArray(
        treeDepth: treeDepth,
        key: key,
        parent: parent,
      );

      final children = _buildArrayNodes(
        object: value,
        treeDepth: treeDepth,
        parent: arrayNode,
      );

      arrayNode.value = children;

      map[key] = arrayNode;
    } else {
      map[key] = NodeViewModelState.fromProperty(
        key: key,
        value: value,
        treeDepth: treeDepth,
        parent: parent,
      );
    }
  });
  return map;
}

List<NodeViewModelState> _buildArrayNodes({
  required List<dynamic> object,
  int treeDepth = 0,
  NodeViewModelState? parent,
}) {
  final array = <NodeViewModelState>[];
  for (var i = 0; i < object.length; i++) {
    final dynamic arrayValue = object[i];

    if (arrayValue is Map<String, dynamic>) {
      final classNode = NodeViewModelState.fromClass(
        key: i.toString(),
        treeDepth: treeDepth + 1,
        parent: parent,
      );

      final children = _buildClassNodes(
        object: arrayValue,
        treeDepth: treeDepth + 2,
        parent: classNode,
      );

      classNode.value = children;

      array.add(classNode);
    } else {
      array.add(
        NodeViewModelState.fromProperty(
          key: i.toString(),
          value: arrayValue,
          treeDepth: treeDepth + 1,
          parent: parent,
        ),
      );
    }
  }
  return array;
}

@visibleForTesting
List<NodeViewModelState> flatten(dynamic object) {
  if (object is List) {
    return _flattenArray(object as List<NodeViewModelState>);
  }
  return _flattenClass(object as Map<String, NodeViewModelState>);
}

List<NodeViewModelState> _flattenClass(Map<String, NodeViewModelState> object) {
  final flatList = <NodeViewModelState>[];
  object.forEach((key, value) {
    flatList.add(value);

    if (!value.isCollapsed) {
      if (value.value is Map) {
        flatList.addAll(
          _flattenClass(value.value as Map<String, NodeViewModelState>),
        );
      } else if (value.value is List) {
        flatList.addAll(_flattenArray(value.value as List<NodeViewModelState>));
      }
    }
  });
  return flatList;
}

List<NodeViewModelState> _flattenArray(List<NodeViewModelState> objects) {
  final flatList = <NodeViewModelState>[];
  for (final object in objects) {
    flatList.add(object);
    if (!object.isCollapsed &&
        object.value is Map<String, NodeViewModelState>) {
      flatList.addAll(
        _flattenClass(object.value as Map<String, NodeViewModelState>),
      );
    }
  }
  return flatList;
}

/// Handles the data and manages the state of a json explorer.
///
/// The data must be initialized by calling the [buildNodes] method.
/// This method takes a raw JSON object [Map<String, dynamic>] or
/// [List<dynamic>] and builds a flat node list of [NodeViewModelState].
///
///
/// The property [displayNodes] contains a flat list of all nodes that can be
/// displayed.
/// This means that each node property is an element in this list, even inner
/// class properties.
///
/// ## Example
///
/// {@tool snippet}
///
/// Considering the following JSON file with inner classes and properties:
///
/// ```json
/// {
///   "someClass": {
///     "classField": "value",
///     "innerClass": {
///         "innerClassField": "value"
///         }
///     }
///     "arrayField": [0, 1]
/// }
///
/// The [displayNodes] representation is going to look like this:
/// [
///   node {"someClass": ...},
///   node {"classField": ...},
///   node {"innerClass": ...},
///   node {"innerClassField": ...},
///   node {"arrayField": ...},
///   node {"0": ...},
///   node {"1": ...},
/// ]
///
/// ```
/// {@end-tool}
///
/// This data structure allows us to render the nodes easily using a
/// [ListView.builder] for example, or any other kind of list rendering widget.
///
class JsonExplorerStore extends ChangeNotifier {
  List<NodeViewModelState> _displayNodes = [];
  UnmodifiableListView<NodeViewModelState> _allNodes = UnmodifiableListView([]);

  final _searchResults = <SearchResult>[];
  String _searchTerm = '';
  var _focusedSearchResultIndex = 0;

  /// Gets the list of nodes to be displayed.
  ///
  /// [notifyListeners] is called whenever this value changes.
  /// The returned [Iterable] is closed for modification.
  UnmodifiableListView<NodeViewModelState> get displayNodes =>
      UnmodifiableListView(_displayNodes);

  /// Gets the current search term.
  ///
  /// [notifyListeners] is called whenever this value changes.
  String get searchTerm => _searchTerm;

  /// Gets a list containing the nodes found by the current search term.
  ///
  /// [notifyListeners] is called whenever this value changes.
  /// The returned [Iterable] is closed for modification.
  UnmodifiableListView<SearchResult> get searchResults =>
      UnmodifiableListView(_searchResults);

  /// Gets the current focused search node index.
  /// If there are search results, this is going to be an index of
  /// [searchResults] list. It always going to be 0 by default.
  ///
  /// Use [focusNextSearchResult] and [focusPreviousSearchResult] to change the
  /// current focused search node.
  ///
  /// [notifyListeners] is called whenever this value changes.
  int get focusedSearchResultIndex => _focusedSearchResultIndex;

  /// Gets the current focused search result.
  ///
  /// Use [focusNextSearchResult] and [focusPreviousSearchResult] to change the
  /// current focused search node.
  ///
  /// [notifyListeners] is called whenever this value changes.
  SearchResult get focusedSearchResult =>
      _searchResults[_focusedSearchResultIndex];

  /// Collapses the given [node] so its children won't be visible.
  ///
  /// This will change the [node] [NodeViewModelState.isCollapsed] property to
  /// true. But its children won't change states, so when the node is expanded
  /// its children states are unchanged.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  ///
  /// See also:
  /// * [expandNode]
  void collapseNode(NodeViewModelState node) {
    if (node.isCollapsed || !node.isRoot) {
      return;
    }

    final nodeIndex = _displayNodes.indexOf(node) + 1;
    final children = _visibleChildrenCount(node) - 1;
    _displayNodes.removeRange(nodeIndex, nodeIndex + children);
    node.collapse();
    notifyListeners();
  }

  /// Collapses all nodes.
  ///
  /// This collapses every single node of the data structure, meaning that only
  /// the upper root nodes will be in the [displayNodes] list.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  ///
  /// See also:
  /// * [expandAll]
  void collapseAll() {
    final rootNodes =
        _displayNodes.where((node) => node.treeDepth == 0 && !node.isCollapsed);
    final collapsedNodes = List<NodeViewModelState>.from(_displayNodes);
    for (final node in rootNodes) {
      final nodeIndex = collapsedNodes.indexOf(node) + 1;
      final children = _visibleChildrenCount(node) - 1;
      collapsedNodes.removeRange(nodeIndex, nodeIndex + children);
    }

    for (final node in _allNodes) {
      node.collapse();
    }
    _displayNodes = collapsedNodes;
    notifyListeners();
  }

  /// Expands the given [node] so its children become visible.
  ///
  /// This will change the [node] [NodeViewModelState.isCollapsed] property to
  /// false. But its children won't change states, so when the node is expanded
  /// its children states are unchanged.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  ///
  /// See also:
  /// * [collapseNode]
  void expandNode(NodeViewModelState node) {
    if (!node.isCollapsed || !node.isRoot) {
      return;
    }

    final nodeIndex = _displayNodes.indexOf(node) + 1;
    final nodes = flatten(node.value);
    _displayNodes.insertAll(nodeIndex, nodes);
    node.expand();
    notifyListeners();
  }

  /// Expands all nodes.
  ///
  /// This expands every single node of the data structure, meaning that all
  /// nodes will be in the [displayNodes] list.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  ///
  /// See also:
  /// * [collapseAll]
  void expandAll() {
    for (final node in _allNodes) {
      node.expand();
    }
    _displayNodes = List.from(_allNodes);
    notifyListeners();
  }

  /// Returns true if all nodes are expanded, otherwise returns false.
  bool areAllExpanded() {
    return _displayNodes.length == _allNodes.length;
  }

  /// Returns true if all nodes are collapsed, otherwise returns false.
  bool areAllCollapsed() {
    for (final node in _displayNodes) {
      if (node.childrenCount > 0 && !node._isCollapsed) {
        return false;
      }
    }

    return true;
  }

  /// Executes a search in the current data structure looking for the given
  /// search [term].
  ///
  /// The search looks for matching terms in both key and values from all nodes.
  /// The results can be retrieved in the [searchResults] lists.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  void search(String term) {
    _searchTerm = term.toLowerCase();
    _searchResults.clear();
    _focusedSearchResultIndex = 0;
    notifyListeners();

    if (term.isNotEmpty) {
      _doSearch();
    }
  }

  /// Sets the focus on the next search result.
  ///
  /// Does nothing if there are no results or the last node is already focused.
  ///
  /// If [loop] is `true` and the current focused search result is the last
  /// element of [searchResults], the first element of [searchResults] is
  /// focused.
  ///
  /// See also:
  /// * [focusPreviousSearchResult]
  void focusNextSearchResult({bool loop = false}) {
    if (searchResults.isEmpty) {
      return;
    }

    if (_focusedSearchResultIndex < _searchResults.length - 1) {
      _focusedSearchResultIndex += 1;
      notifyListeners();
    } else if (loop) {
      _focusedSearchResultIndex = 0;
      notifyListeners();
    }
  }

  /// Sets the focus on the previous search result.
  ///
  /// Does nothing if there are no results or the first node is already focused.
  ///
  /// If [loop] is `true` and the current focused search result is the first
  /// element of [searchResults], the last element of [searchResults] is
  /// focused.
  ///
  /// See also:
  /// * [focusNextSearchResult]
  void focusPreviousSearchResult({bool loop = false}) {
    if (searchResults.isEmpty) {
      return;
    }

    if (_focusedSearchResultIndex > 0) {
      _focusedSearchResultIndex -= 1;
      notifyListeners();
    } else if (loop) {
      _focusedSearchResultIndex = _searchResults.length - 1;
      notifyListeners();
    }
  }

  /// Uses the given [jsonObject] to build the [displayNodes] list.
  ///
  /// If [areAllCollapsed] is true, then all nodes will be collapsed, and
  /// initially only upper root nodes will be in the list.
  ///
  /// [notifyListeners] is called to notify all registered listeners.
  Future buildNodes(dynamic jsonObject, {bool areAllCollapsed = false}) async {
    final builtNodes = buildViewModelNodes(jsonObject);
    final flatList = flatten(builtNodes);

    _allNodes = UnmodifiableListView(flatList);
    _displayNodes = List.from(flatList);
    if (areAllCollapsed) {
      collapseAll();
    } else {
      notifyListeners();
    }
  }

  int _visibleChildrenCount(NodeViewModelState node) {
    final children = node.children;
    var count = 1;
    for (final child in children) {
      count =
          child.isCollapsed ? count + 1 : count + _visibleChildrenCount(child);
    }
    return count;
  }

  void _doSearch() {
    for (final node in _allNodes) {
      final matchesIndexes = _getSearchTermMatchesIndexes(node.key);

      for (final matchIndex in matchesIndexes) {
        _searchResults.add(
          SearchResult(
            node,
            matchLocation: SearchMatchLocation.key,
            matchIndex: matchIndex,
          ),
        );
      }

      if (!node.isRoot) {
        final matchesIndexes =
            _getSearchTermMatchesIndexes(node.value.toString());

        for (final matchIndex in matchesIndexes) {
          _searchResults.add(
            SearchResult(
              node,
              matchLocation: SearchMatchLocation.value,
              matchIndex: matchIndex,
            ),
          );
        }
      }
    }

    notifyListeners();
  }

  /// Finds all occurences of [searchTerm] in [victim] and retrieves all their
  /// indexes.
  Iterable<int> _getSearchTermMatchesIndexes(String victim) {
    final pattern = RegExp(searchTerm, caseSensitive: false);

    final matches = pattern.allMatches(victim).map((match) => match.start);

    return matches;
  }

  /// Expands all the parent nodes of each [SearchResult.node] in
  /// [searchResults].
  void expandSearchResults() {
    for (final searchResult in searchResults) {
      _expandParentNodes(searchResult.node);
    }
  }

  /// Expands all the parent nodes of the given [node].
  void _expandParentNodes(NodeViewModelState node) {
    final parent = node.parent;

    if (parent == null) {
      return;
    }

    _expandParentNodes(parent);

    expandNode(parent);
  }
}

/// A matched search in the given [node].
///
/// If the match is registered in the node's key, then [matchLocation] is going
/// to be [SearchMatchLocation.key].
///
/// If the match is in the value, then [matchLocation] is
/// [SearchMatchLocation.value].
class SearchResult {
  final NodeViewModelState node;
  final SearchMatchLocation matchLocation;
  final int matchIndex;

  const SearchResult(
    this.node, {
    required this.matchLocation,
    required this.matchIndex,
  });
}

/// The location of the search match in a node.
///
/// Can be in the node's key or in the node's value.
enum SearchMatchLocation {
  key,
  value,
}
