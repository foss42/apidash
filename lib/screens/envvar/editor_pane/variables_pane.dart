import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';

class EditEnvironmentVariables extends ConsumerStatefulWidget {
  const EditEnvironmentVariables({super.key});

  @override
  ConsumerState<EditEnvironmentVariables> createState() =>
      EditEnvironmentVariablesState();
}

class EditEnvironmentVariablesState
    extends ConsumerState<EditEnvironmentVariables> {
  late int seed;
  final random = Random.secure();
  late List<EnvironmentVariableModel> variableRows;
  bool isAddingRow = false;
  OverlayEntry? _overlayEntry;
  FocusNode? _currentFocusNode;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _currentFocusNode?.removeListener(_handleOverlayFocusChange);
    _currentFocusNode = null;
  }

  void _handleOverlayFocusChange() {
    if (_currentFocusNode != null && !_currentFocusNode!.hasFocus) {
      _removeOverlay();
    }
  }

  void _showOverlay(
    GlobalKey key,
    String text,
    TextStyle textStyle,
    ColorScheme clrScheme,
    FocusNode focusNode,
    TextEditingController controller,
    InputDecoration decoration,
  ) {
    _removeOverlay();

    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _currentFocusNode = focusNode;
    _currentFocusNode?.addListener(_handleOverlayFocusChange);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: clrScheme.surface,
              // borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: kColorWhite.withOpacity(0.5)),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: textStyle,
              decoration: decoration,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autofocus: true,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onOverlayToggle(
    bool show,
    GlobalKey key,
    String text,
    TextStyle textStyle,
    ColorScheme clrScheme,
    FocusNode focusNode,
    TextEditingController controller,
    InputDecoration decoration,
  ) {
    if (show) {
      _showOverlay(key, text, textStyle, clrScheme, focusNode, controller, decoration);
    } else {
      _removeOverlay();
    }
  }

  void _onFieldChange(String selectedId) {
    final environment = ref.read(selectedEnvironmentModelProvider);
    final secrets = getEnvironmentSecrets(environment);
    ref.read(environmentsStateNotifierProvider.notifier).updateEnvironment(
      selectedId,
      values: [...variableRows.sublist(0, variableRows.length - 1), ...secrets],
    );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
    ref.watch(selectedEnvironmentModelProvider
        .select((environment) => getEnvironmentVariables(environment).length));
    var rows =
        getEnvironmentVariables(ref.read(selectedEnvironmentModelProvider));
    variableRows = rows.isEmpty
        ? [
            kEnvironmentVariableEmptyModel,
          ]
        : rows + [kEnvironmentVariableEmptyModel];
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kNameCheckbox),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text("Variable name"),
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text(" jars value"),
      ),
      DataColumn2(
        label: Text(''),
        fixedWidth: 32,
      ),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(
      variableRows.length,
      (index) {
        bool isLast = index + 1 == variableRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-variables-row-$seed"),
          cells: <DataCell>[
            DataCell(
              ADCheckBox(
                keyId: "$selectedId-$index-variables-c-$seed",
                value: variableRows[index].enabled,
                onChanged: isLast
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            variableRows[index] =
                                variableRows[index].copyWith(enabled: value);
                          });
                        }
                        _onFieldChange(selectedId!);
                      },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              CellField(
                keyId: "$selectedId-$index-variables-k-$seed",
                initialValue: variableRows[index].key,
                hintText: "Add Variable",
                onChanged: (value) {
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    variableRows[index] =
                        variableRows[index].copyWith(key: value, enabled: true);
                    variableRows.add(kEnvironmentVariableEmptyModel);
                  } else {
                    variableRows[index] =
                        variableRows[index].copyWith(key: value);
                  }
                  _onFieldChange(selectedId!);
                },
                colorScheme: Theme.of(context).colorScheme,
                onOverlayToggle: _onOverlayToggle,
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  "=",
                  style: kCodeStyle,
                ),
              ),
            ),
            DataCell(
              CellField(
                keyId: "$selectedId-$index-variables-v-$seed",
                initialValue: variableRows[index].value,
                hintText: kHintAddValue,
                onChanged: (value) {
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    variableRows[index] = variableRows[index]
                        .copyWith(value: value, enabled: true);
                    variableRows.add(kEnvironmentVariableEmptyModel);
                  } else {
                    variableRows[index] =
                        variableRows[index].copyWith(value: value);
                  }
                  _onFieldChange(selectedId!);
                },
                colorScheme: Theme.of(context).colorScheme,
                onOverlayToggle: _onOverlayToggle,
              ),
            ),
            DataCell(
              InkWell(
                onTap: isLast
                    ? null
                    : () {
                        seed = random.nextInt(kRandMax);
                        if (variableRows.length == 2) {
                          setState(() {
                            variableRows = [
                              kEnvironmentVariableEmptyModel,
                            ];
                          });
                        } else {
                          variableRows.removeAt(index);
                        }
                        _onFieldChange(selectedId!);
                      },
                child: Theme.of(context).brightness == Brightness.dark
                    ? kIconRemoveDark
                    : kIconRemoveLight,
              ),
            ),
          ],
        );
      },
    );

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: kBorderRadius12,
          ),
          margin: kP10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(scrollbarTheme: kDataTableScrollbarTheme),
                  child: DataTable2(
                    columnSpacing: 12,
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    headingRowHeight: 0,
                    dataRowHeight: null,
                    bottomMargin: kDataTableBottomPadding,
                    isVerticalScrollBarVisible: true,
                    columns: columns,
                    rows: dataRows,
                  ),
                ),
              ),
              kVSpacer40,
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: kPb15,
            child: ElevatedButton.icon(
              onPressed: () {
                variableRows.add(kEnvironmentVariableEmptyModel);
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                kLabelAddVariable,
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}