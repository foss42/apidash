import 'package:apidash/consts.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

import 'git_diff_chrome.dart';
import 'git_diff_side_by_side_shell.dart';
import 'git_json_fallback_column.dart';

RequestModel? parseRequestModel(Map<String, Object?>? json) {
  if (json == null) return null;
  try {
    var requestModel = RequestModel.fromJson(json);
    if (requestModel.httpRequestModel == null &&
        requestModel.aiRequestModel == null) {
      requestModel = requestModel.copyWith(
        httpRequestModel: const HttpRequestModel(),
      );
    }
    return requestModel;
  } catch (_) {
    return null;
  }
}

class GitRequestVisualDiff extends StatelessWidget {
  const GitRequestVisualDiff({
    super.key,
    required this.original,
    required this.current,
    this.originalRaw,
    this.currentRaw,
  });

  final RequestModel? original;
  final RequestModel? current;
  final String? originalRaw;
  final String? currentRaw;

  @override
  Widget build(BuildContext context) {
    return GitDiffSideBySideShell(
      original: _RequestDiffColumn(
        model: original,
        otherModel: current,
        side: _DiffSide.original,
        raw: originalRaw,
        fieldKey: 'git-diff-request-original',
      ),
      current: _RequestDiffColumn(
        model: current,
        otherModel: original,
        side: _DiffSide.current,
        raw: currentRaw,
        fieldKey: 'git-diff-request-current',
      ),
    );
  }
}

enum _DiffSide { original, current }

class _RequestDiffSlots {
  const _RequestDiffSlots({
    required this.showName,
    required this.showDescription,
    required this.showType,
    required this.showMethod,
    required this.showUrl,
    required this.showAi,
    required this.showAuth,
    required this.showHeaders,
    required this.showParams,
    required this.showBody,
    required this.showGraphqlQuery,
    required this.showPreScript,
    required this.showPostScript,
  });

  final bool showName;
  final bool showDescription;
  final bool showType;
  final bool showMethod;
  final bool showUrl;
  final bool showAi;
  final bool showAuth;
  final bool showHeaders;
  final bool showParams;
  final bool showBody;
  final bool showGraphqlQuery;
  final bool showPreScript;
  final bool showPostScript;

  bool get hasAny =>
      showName ||
      showDescription ||
      showType ||
      showMethod ||
      showUrl ||
      showAi ||
      showAuth ||
      showHeaders ||
      showParams ||
      showBody ||
      showGraphqlQuery ||
      showPreScript ||
      showPostScript;

  factory _RequestDiffSlots.compare(
    RequestModel? model,
    RequestModel? otherModel,
  ) {
    final http = model?.httpRequestModel;
    final otherHttp = otherModel?.httpRequestModel;
    final effectiveApiType = model?.apiType ?? otherModel?.apiType;
    // One side missing (added/deleted request): show content for context.
    // Both sides present: show only fields that actually differ.
    final oneMissing = model == null || otherModel == null;

    bool changed(Object? a, Object? b) {
      if (oneMissing) {
        return _hasDiffValue(a) || _hasDiffValue(b);
      }
      return !_diffValueEquals(a, b);
    }

    final isRest = effectiveApiType == APIType.rest;
    final isGraphql = effectiveApiType == APIType.graphql;
    final isAi = effectiveApiType == APIType.ai;

    return _RequestDiffSlots(
      showName: changed(model?.name, otherModel?.name),
      showDescription: changed(model?.description, otherModel?.description),
      showType: changed(model?.apiType, otherModel?.apiType),
      showMethod:
          isRest && changed(http?.method, otherHttp?.method),
      showUrl: isRest && changed(http?.url, otherHttp?.url),
      showAi:
          isAi &&
          (oneMissing
              ? (model?.aiRequestModel != null ||
                  otherModel?.aiRequestModel != null)
              : !_aiRequestEquals(
                model.aiRequestModel,
                otherModel.aiRequestModel,
              )),
      showAuth: changed(
        _configuredAuthType(http),
        _configuredAuthType(otherHttp),
      ),
      showHeaders: oneMissing
          ? ((http?.headersMap.isNotEmpty ?? false) ||
              (otherHttp?.headersMap.isNotEmpty ?? false))
          : !_stringMapsEqual(http?.headersMap, otherHttp?.headersMap),
      showParams: oneMissing
          ? ((http?.paramsMap.isNotEmpty ?? false) ||
              (otherHttp?.paramsMap.isNotEmpty ?? false))
          : !_stringMapsEqual(http?.paramsMap, otherHttp?.paramsMap),
      showBody: isRest &&
          !_diffValueEquals(
            _normalizedBodySignature(http),
            _normalizedBodySignature(otherHttp),
          ),
      showGraphqlQuery: isGraphql && changed(http?.query, otherHttp?.query),
      showPreScript: changed(
        model?.preRequestScript,
        otherModel?.preRequestScript,
      ),
      showPostScript: changed(
        model?.postRequestScript,
        otherModel?.postRequestScript,
      ),
    );
  }
}

class _RequestDiffColumn extends StatelessWidget {
  const _RequestDiffColumn({
    required this.model,
    required this.otherModel,
    required this.side,
    required this.raw,
    required this.fieldKey,
  });

  final RequestModel? model;
  final RequestModel? otherModel;
  final _DiffSide side;
  final String? raw;
  final String fieldKey;

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      if (raw != null && raw!.trim().isNotEmpty) {
        return GitJsonFallbackColumn(raw: raw, fieldKey: fieldKey);
      }
      if (otherModel != null) {
        return _RequestNoContentColumn(
          referenceModel: otherModel!,
          slots: _RequestDiffSlots.compare(null, otherModel),
        );
      }
      return const GitDiffEmptyState();
    }

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final http = model!.httpRequestModel;
    final otherHttp = otherModel?.httpRequestModel;
    final apiType = model!.apiType;
    final slots = _RequestDiffSlots.compare(model, otherModel);

    if (!slots.hasAny) {
      return const GitDiffEmptyState();
    }

    Widget field(String label, Widget child, {GitDiffChangeKind? change}) {
      return GitDiffField(label: label, change: change, child: child);
    }

    return SingleChildScrollView(
      padding: kP12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (slots.showName)
            field(
              'Name',
              model!.name.trim().isEmpty
                  ? const _GitDiffNoContentBox()
                  : Text(
                      model!.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              change: _fieldChangeKind(model!.name, otherModel?.name, side),
            ),
          if (slots.showDescription)
            field(
              'Description',
              model!.description.trim().isEmpty
                  ? const _GitDiffNoContentBox()
                  : Text(
                      model!.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
              change: _fieldChangeKind(
                model!.description,
                otherModel?.description,
                side,
              ),
            ),
          if (slots.showType)
            field(
              'Type',
              Text(
                apiType.label,
                style: kCodeStyle.copyWith(fontWeight: FontWeight.w600),
              ),
              change: _fieldChangeKind(apiType, otherModel?.apiType, side),
            ),
          if (slots.showMethod)
            apiType == APIType.rest && http != null
                ? field(
                  'Method',
                  Text(
                    http.method.name.toUpperCase(),
                    style: kCodeStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: getAPIColor(
                        apiType,
                        method: http.method,
                        brightness: Theme.of(context).brightness,
                      ),
                    ),
                  ),
                  change: _fieldChangeKind(
                    http.method,
                    otherHttp?.method,
                    side,
                  ),
                )
                : field('Method', const _GitDiffNoContentBox()),
          if (slots.showUrl)
            apiType == APIType.rest && http != null
                ? field(
                  'URL',
                  ReadOnlyTextField(
                    initialValue: http.url,
                    style: kCodeStyle,
                  ),
                  change: _fieldChangeKind(http.url, otherHttp?.url, side),
                )
                : field('URL', const _GitDiffNoContentBox()),
          if (slots.showAi) ...[
            apiType == APIType.ai && model!.aiRequestModel != null
                ? _AiRequestDiffBody(
                  ai: model!.aiRequestModel!,
                  otherAi: otherModel?.aiRequestModel,
                  side: side,
                  idSuffix: model!.id,
                )
                : _AiRequestNoContentBody(ai: otherModel!.aiRequestModel!),
          ],
          if (slots.showAuth)
            field(
              kLabelAuth,
              _hasConfiguredAuth(http)
                  ? Text(
                      http!.authModel!.type.displayType,
                      style: kCodeStyle.copyWith(fontWeight: FontWeight.w600),
                    )
                  : const _GitDiffNoContentBox(),
              change: _fieldChangeKind(
                _configuredAuthType(http),
                _configuredAuthType(otherHttp),
                side,
              ),
            ),
          if (slots.showHeaders)
            field(
              kLabelHeaders,
              http == null || http.headersMap.isEmpty
                  ? const _GitDiffNoContentBox()
                  : _GitDiffKeyValueList(
                    rows: http.headersMap,
                    otherRows: otherHttp?.headersMap ?? const {},
                    side: side,
                  ),
            ),
          if (slots.showParams)
            field(
              kLabelURLParams,
              http == null || http.paramsMap.isEmpty
                  ? const _GitDiffNoContentBox()
                  : _GitDiffKeyValueList(
                    rows: http.paramsMap,
                    otherRows: otherHttp?.paramsMap ?? const {},
                    side: side,
                  ),
            ),
          if (slots.showBody)
            field(
              kLabelBody,
              http == null || _normalizedBodySignature(http) == null
                  ? const _GitDiffNoContentBox(minHeight: 160)
                  : SizedBox(
                    height: 160,
                    child: switch (http.bodyContentType) {
                      ContentType.json => JsonTextFieldEditor(
                        fieldKey: _fieldEditorKey('json', model!.id, side),
                        initialValue: http.body,
                        readOnly: true,
                        isDark: Theme.of(context).brightness == Brightness.dark,
                      ),
                      ContentType.formdata => _GitDiffFormDataList(
                        rows: http.formData ?? [],
                        otherRows: otherHttp?.formData ?? const [],
                        side: side,
                      ),
                      _ => TextFieldEditor(
                        fieldKey: _fieldEditorKey('body', model!.id, side),
                        initialValue: http.body,
                        readOnly: true,
                      ),
                    },
                  ),
              change: _fieldChangeKind(
                _normalizedBodySignature(http),
                _normalizedBodySignature(otherHttp),
                side,
              ),
            ),
          if (slots.showGraphqlQuery)
            field(
              kLabelQuery,
              http == null || (http.query?.trim().isEmpty ?? true)
                  ? const _GitDiffNoContentBox(minHeight: 160)
                  : SizedBox(
                    height: 160,
                    child: TextFieldEditor(
                      fieldKey: _fieldEditorKey('query', model!.id, side),
                      initialValue: http.query,
                      readOnly: true,
                    ),
                  ),
              change: _fieldChangeKind(http?.query, otherHttp?.query, side),
            ),
          if (slots.showPreScript)
            field(
              kLabelPreRequest,
              model!.preRequestScript?.trim().isEmpty ?? true
                  ? const _GitDiffNoContentBox(minHeight: 120)
                  : SizedBox(
                    height: 120,
                    child: TextFieldEditor(
                      fieldKey: _fieldEditorKey('pre', model!.id, side),
                      initialValue: model!.preRequestScript,
                      readOnly: true,
                    ),
                  ),
              change: _fieldChangeKind(
                model!.preRequestScript,
                otherModel?.preRequestScript,
                side,
              ),
            ),
          if (slots.showPostScript)
            field(
              kLabelPostResponse,
              model!.postRequestScript?.trim().isEmpty ?? true
                  ? const _GitDiffNoContentBox(minHeight: 120)
                  : SizedBox(
                    height: 120,
                    child: TextFieldEditor(
                      fieldKey: _fieldEditorKey('post', model!.id, side),
                      initialValue: model!.postRequestScript,
                      readOnly: true,
                    ),
                  ),
              change: _fieldChangeKind(
                model!.postRequestScript,
                otherModel?.postRequestScript,
                side,
              ),
            ),
        ],
      ),
    );
  }
}

class _RequestNoContentColumn extends StatelessWidget {
  const _RequestNoContentColumn({
    required this.referenceModel,
    required this.slots,
  });

  final RequestModel referenceModel;
  final _RequestDiffSlots slots;

  @override
  Widget build(BuildContext context) {
    Widget field(String label, Widget child) {
      return GitDiffField(label: label, child: child);
    }

    return SingleChildScrollView(
      padding: kP12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (slots.showName) field('Name', const _GitDiffNoContentBox()),
          if (slots.showDescription)
            field('Description', const _GitDiffNoContentBox()),
          if (slots.showType) field('Type', const _GitDiffNoContentBox()),
          if (slots.showMethod) field('Method', const _GitDiffNoContentBox()),
          if (slots.showUrl) field('URL', const _GitDiffNoContentBox()),
          if (slots.showAi) ...[
            referenceModel.aiRequestModel == null
                ? field('Model', const _GitDiffNoContentBox(minHeight: 220))
                : _AiRequestNoContentBody(ai: referenceModel.aiRequestModel!),
          ],
          if (slots.showAuth) field(kLabelAuth, const _GitDiffNoContentBox()),
          if (slots.showHeaders)
            field(kLabelHeaders, const _GitDiffNoContentBox()),
          if (slots.showParams)
            field(kLabelURLParams, const _GitDiffNoContentBox()),
          if (slots.showBody)
            field(kLabelBody, const _GitDiffNoContentBox(minHeight: 160)),
          if (slots.showGraphqlQuery)
            field(kLabelQuery, const _GitDiffNoContentBox(minHeight: 160)),
          if (slots.showPreScript)
            field(
              kLabelPreRequest,
              const _GitDiffNoContentBox(minHeight: 120),
            ),
          if (slots.showPostScript)
            field(
              kLabelPostResponse,
              const _GitDiffNoContentBox(minHeight: 120),
            ),
        ],
      ),
    );
  }
}

class _AiRequestDiffBody extends StatelessWidget {
  const _AiRequestDiffBody({
    required this.ai,
    required this.otherAi,
    required this.side,
    required this.idSuffix,
  });

  final AIRequestModel ai;
  final AIRequestModel? otherAi;
  final _DiffSide side;
  final String idSuffix;

  @override
  Widget build(BuildContext context) {
    final meta = <String, String>{
      if (ai.modelApiProvider != null) 'Provider': ai.modelApiProvider!.name,
      if (ai.model != null && ai.model!.trim().isNotEmpty) 'Model': ai.model!,
      if (ai.stream != null) 'Stream': ai.stream! ? 'true' : 'false',
    };
    final otherMeta = <String, String>{
      if (otherAi?.modelApiProvider != null)
        'Provider': otherAi!.modelApiProvider!.name,
      if (otherAi?.model != null && otherAi!.model!.trim().isNotEmpty)
        'Model': otherAi!.model!,
      if (otherAi?.stream != null)
        'Stream': otherAi!.stream! ? 'true' : 'false',
    };

    final configs = ai.getModelConfigMap().map(
      (key, value) => MapEntry(key, '${value ?? ''}'),
    );
    final otherConfigs =
        otherAi?.getModelConfigMap().map(
          (key, value) => MapEntry(key, '${value ?? ''}'),
        ) ??
        const <String, String>{};

    final oneMissing = otherAi == null;

    Widget field(String label, Widget child, {GitDiffChangeKind? change}) {
      return GitDiffField(label: label, change: change, child: child);
    }

    final showMeta =
        oneMissing
            ? (meta.isNotEmpty || otherMeta.isNotEmpty)
            : !_stringMapsEqual(meta, otherMeta);
    final showUrl =
        oneMissing
            ? (ai.url.trim().isNotEmpty ||
                (otherAi?.url.trim().isNotEmpty ?? false))
            : !_diffValueEquals(ai.url, otherAi?.url);
    final showSystem =
        oneMissing
            ? (ai.systemPrompt.trim().isNotEmpty ||
                (otherAi?.systemPrompt.trim().isNotEmpty ?? false))
            : !_diffValueEquals(ai.systemPrompt, otherAi?.systemPrompt);
    final showUser =
        oneMissing
            ? (ai.userPrompt.trim().isNotEmpty ||
                (otherAi?.userPrompt.trim().isNotEmpty ?? false))
            : !_diffValueEquals(ai.userPrompt, otherAi?.userPrompt);
    final showConfigs =
        oneMissing
            ? (configs.isNotEmpty || otherConfigs.isNotEmpty)
            : !_stringMapsEqual(configs, otherConfigs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showMeta)
          field(
            'Model',
            meta.isEmpty
                ? const _GitDiffNoContentBox()
                : _GitDiffKeyValueList(
                  rows: meta,
                  otherRows: otherMeta,
                  side: side,
                ),
          ),
        if (showUrl)
          field(
            'URL',
            ai.url.trim().isEmpty
                ? const _GitDiffNoContentBox()
                : ReadOnlyTextField(initialValue: ai.url, style: kCodeStyle),
            change: _fieldChangeKind(ai.url, otherAi?.url, side),
          ),
        if (showSystem)
          field(
            kLabelSystemPrompt,
            ai.systemPrompt.trim().isEmpty
                ? const _GitDiffNoContentBox(minHeight: 120)
                : SizedBox(
                  height: 120,
                  child: TextFieldEditor(
                    fieldKey: _fieldEditorKey('ai-system', idSuffix, side),
                    initialValue: ai.systemPrompt,
                    readOnly: true,
                  ),
                ),
            change: _fieldChangeKind(
              ai.systemPrompt,
              otherAi?.systemPrompt,
              side,
            ),
          ),
        if (showUser)
          field(
            kLabelUserPromptInput,
            ai.userPrompt.trim().isEmpty
                ? const _GitDiffNoContentBox(minHeight: 120)
                : SizedBox(
                  height: 120,
                  child: TextFieldEditor(
                    fieldKey: _fieldEditorKey('ai-user', idSuffix, side),
                    initialValue: ai.userPrompt,
                    readOnly: true,
                  ),
                ),
            change: _fieldChangeKind(ai.userPrompt, otherAi?.userPrompt, side),
          ),
        if (showConfigs)
          field(
            'Model Config',
            configs.isEmpty
                ? const _GitDiffNoContentBox()
                : _GitDiffKeyValueList(
                  rows: configs,
                  otherRows: otherConfigs,
                  side: side,
                ),
          ),
      ],
    );
  }
}

class _AiRequestNoContentBody extends StatelessWidget {
  const _AiRequestNoContentBody({required this.ai});

  final AIRequestModel ai;

  @override
  Widget build(BuildContext context) {
    final configs = ai.getModelConfigMap();
    final hasMeta =
        ai.modelApiProvider != null ||
        (ai.model?.trim().isNotEmpty ?? false) ||
        ai.stream != null;

    Widget field(String label, Widget child) {
      return GitDiffField(label: label, child: child);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasMeta) field('Model', const _GitDiffNoContentBox()),
        if (ai.url.trim().isNotEmpty)
          field('URL', const _GitDiffNoContentBox()),
        if (ai.systemPrompt.trim().isNotEmpty)
          field(
            kLabelSystemPrompt,
            const _GitDiffNoContentBox(minHeight: 120),
          ),
        if (ai.userPrompt.trim().isNotEmpty)
          field(
            kLabelUserPromptInput,
            const _GitDiffNoContentBox(minHeight: 120),
          ),
        if (configs.isNotEmpty)
          field('Model Config', const _GitDiffNoContentBox()),
      ],
    );
  }
}

class _GitDiffKeyValueList extends StatelessWidget {
  const _GitDiffKeyValueList({
    required this.rows,
    required this.otherRows,
    required this.side,
  });

  final Map<String, String> rows;
  final Map<String, String> otherRows;
  final _DiffSide side;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final keys = _orderedKeys(rows, otherRows);
    final filterUnchanged = rows.isNotEmpty && otherRows.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final key in keys)
          if (!filterUnchanged || _stringMapKeyChanged(key, rows, otherRows))
            rows.containsKey(key)
                ? GitDiffKvRow(
                    keyText: key,
                    change: _mapEntryChangeKind(
                      key: key,
                      value: rows[key],
                      otherRows: otherRows,
                      side: side,
                    ),
                    value: Text(
                      rows[key] ?? '',
                      style: kCodeStyle.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : GitDiffHighlightBox(
                    change: side == _DiffSide.current
                        ? null
                        : GitDiffChangeKind.removed,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: const _GitDiffNoContentBox(),
                  ),
      ],
    );
  }
}

class _GitDiffFormDataList extends StatelessWidget {
  const _GitDiffFormDataList({
    required this.rows,
    required this.otherRows,
    required this.side,
  });

  final List<FormDataModel> rows;
  final List<FormDataModel> otherRows;
  final _DiffSide side;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mergedRows = _orderedFormDataRows(rows, otherRows);
    final filterUnchanged = rows.isNotEmpty && otherRows.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in mergedRows)
          if (entry == null
              ? true
              : !filterUnchanged ||
                  _formDataChangeKind(
                        row: entry,
                        otherRows: otherRows,
                        side: side,
                      ) !=
                      null)
            entry == null
                ? const GitDiffHighlightBox(
                    margin: EdgeInsets.only(bottom: 6),
                    child: _GitDiffNoContentBox(),
                  )
                : GitDiffKvRow(
                    keyText: entry.name,
                    change: _formDataChangeKind(
                      row: entry,
                      otherRows: otherRows,
                      side: side,
                    ),
                    value: Text(
                      entry.value,
                      style: kCodeStyle.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    footer: entry.type == FormDataType.file
                        ? Text(
                            entry.type.name,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          )
                        : null,
                  ),
      ],
    );
  }
}

class _GitDiffNoContentBox extends StatelessWidget {
  const _GitDiffNoContentBox({this.minHeight = 36});

  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Text(
        kMsgNoContent,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.72),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

bool _stringMapsEqual(Map<String, String>? a, Map<String, String>? b) {
  final left = a ?? const <String, String>{};
  final right = b ?? const <String, String>{};
  if (left.length != right.length) return false;
  for (final entry in left.entries) {
    if (right[entry.key] != entry.value) return false;
  }
  return true;
}

bool _stringMapKeyChanged(
  String key,
  Map<String, String> rows,
  Map<String, String> otherRows,
) {
  final inRows = rows.containsKey(key);
  final inOther = otherRows.containsKey(key);
  if (inRows != inOther) return true;
  if (!inRows) return false;
  return rows[key] != otherRows[key];
}

bool _aiRequestEquals(AIRequestModel? a, AIRequestModel? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.modelApiProvider != b.modelApiProvider) return false;
  if (!_diffValueEquals(a.model, b.model)) return false;
  if (a.stream != b.stream) return false;
  if (!_diffValueEquals(a.url, b.url)) return false;
  if (!_diffValueEquals(a.systemPrompt, b.systemPrompt)) return false;
  if (!_diffValueEquals(a.userPrompt, b.userPrompt)) return false;
  final aConfigs = a.getModelConfigMap().map(
    (key, value) => MapEntry(key, '${value ?? ''}'),
  );
  final bConfigs = b.getModelConfigMap().map(
    (key, value) => MapEntry(key, '${value ?? ''}'),
  );
  return _stringMapsEqual(aConfigs, bConfigs);
}

GitDiffChangeKind? _fieldChangeKind(
  Object? value,
  Object? otherValue,
  _DiffSide side,
) {
  if (_diffValueEquals(value, otherValue)) return null;

  final hasValue = _hasDiffValue(value);
  final hasOtherValue = _hasDiffValue(otherValue);
  if (!hasValue && !hasOtherValue) return null;
  if (!hasOtherValue && hasValue) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  if (hasOtherValue && !hasValue) {
    return null;
  }
  return GitDiffChangeKind.modified;
}

GitDiffChangeKind? _mapEntryChangeKind({
  required String key,
  required String? value,
  required Map<String, String> otherRows,
  required _DiffSide side,
}) {
  if (value == null) return null;
  if (!otherRows.containsKey(key)) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  return otherRows[key] == value ? null : GitDiffChangeKind.modified;
}

List<String> _orderedKeys(
  Map<String, String> rows,
  Map<String, String> otherRows,
) {
  return [
    ...rows.keys,
    for (final key in otherRows.keys)
      if (!rows.containsKey(key)) key,
  ];
}

GitDiffChangeKind? _formDataChangeKind({
  required FormDataModel row,
  required List<FormDataModel> otherRows,
  required _DiffSide side,
}) {
  final other = _matchingFormData(row, otherRows);
  if (other == null) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  return other.value == row.value && other.type == row.type
      ? null
      : GitDiffChangeKind.modified;
}

FormDataModel? _matchingFormData(FormDataModel row, List<FormDataModel> rows) {
  for (final candidate in rows) {
    if (candidate.name == row.name) return candidate;
  }
  return null;
}

List<FormDataModel?> _orderedFormDataRows(
  List<FormDataModel> rows,
  List<FormDataModel> otherRows,
) {
  return [
    ...rows,
    for (final row in otherRows)
      if (_matchingFormData(row, rows) == null) null,
  ];
}

bool _diffValueEquals(Object? a, Object? b) {
  if (a is String || b is String) {
    return (a?.toString() ?? '') == (b?.toString() ?? '');
  }
  return a == b;
}

bool _hasDiffValue(Object? value) {
  if (value == null) return false;
  if (value is String) return value.trim().isNotEmpty;
  if (value is Iterable) return value.isNotEmpty;
  if (value is Map) return value.isNotEmpty;
  return true;
}

bool _hasConfiguredAuth(HttpRequestModel? model) {
  return _configuredAuthType(model) != null;
}

APIAuthType? _configuredAuthType(HttpRequestModel? model) {
  final type = model?.authModel?.type;
  return type == null || type == APIAuthType.none ? null : type;
}

String? _normalizedBodySignature(HttpRequestModel? model) {
  if (model == null) return null;
  final hasContent = switch (model.bodyContentType) {
    ContentType.formdata => model.formDataMapList.isNotEmpty,
    _ => (model.body ?? '').trim().isNotEmpty,
  };
  if (!hasContent) return null;
  return _requestBodySignature(model);
}

String _requestBodySignature(HttpRequestModel model) {
  if (model.bodyContentType == ContentType.formdata) {
    return '${model.bodyContentType.name}:'
        '${model.formDataList.map(_formDataSignature).join('|')}';
  }
  return '${model.bodyContentType.name}:${model.body ?? ''}';
}

String _formDataSignature(FormDataModel row) {
  return '${row.name}\u0000${row.type.name}\u0000${row.value}';
}

String _fieldEditorKey(String prefix, String id, _DiffSide side) {
  return 'git-diff-${side.name}-$prefix-$id';
}

class GitDiffEmptyState extends StatelessWidget {
  const GitDiffEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: kP20,
        child: Text(
          kMsgNoContent,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
