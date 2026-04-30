import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

/// The SSE event type emitted by Anthropic for streamed text content.
const _kContentBlockDelta = 'content_block_delta';

/// The delta type that carries actual text in an Anthropic stream.
const _kTextDelta = 'text_delta';

class AnthropicModel extends ModelProvider {
  static final instance = AnthropicModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.anthropic,
    url: kAnthropicUrl,
  );

  @override
  HttpRequestModel? createRequest(AIRequestModel? aiRequestModel) {
    if (aiRequestModel == null) {
      return null;
    }
    return HttpRequestModel(
      method: HTTPVerb.post,
      url: aiRequestModel.url,
      headers: const [
        NameValueModel(name: "anthropic-version", value: "2023-06-01"),
      ],
      authModel: aiRequestModel.apiKey == null
          ? null
          : AuthModel(
              type: APIAuthType.apiKey,
              apikey: AuthApiKeyModel(key: aiRequestModel.apiKey!),
            ),
      body: kJsonEncoder.convert({
        "model": aiRequestModel.model,
        "messages": [
          {"role": "system", "content": aiRequestModel.systemPrompt},
          {"role": "user", "content": aiRequestModel.userPrompt},
        ],
        ...aiRequestModel.getModelConfigMap(),
        if (aiRequestModel.stream ?? false) ...{'stream': true},
      }),
    );
  }

  @override
  String? outputFormatter(Map x) {
    return x['content']?[0]['text'];
  }

  /// Extracts streamed text from an Anthropic SSE data payload.
  ///
  /// Anthropic streams use a multi-event SSE protocol. Only
  /// `content_block_delta` events with a `text_delta` carry actual text:
  ///
  /// ```
  /// event: content_block_delta
  /// data: {"type":"content_block_delta","index":0,
  ///        "delta":{"type":"text_delta","text":"Hello"}}
  /// ```
  ///
  /// All other event types (`message_start`, `content_block_start`, `ping`,
  /// `content_block_stop`, `message_delta`, `message_stop`) are irrelevant
  /// for text streaming and return `null` so the caller can skip them.
  ///
  /// The optional [eventType] carries the SSE `event:` field captured by the
  /// stream parser, providing a fast-path check before inspecting the payload.
  @override
  String? streamOutputFormatter(Map x, {String? eventType}) {
    // Fast-path: if the SSE event: field is known and is not a
    // content_block_delta, skip JSON inspection entirely.
    if (eventType != null && eventType != _kContentBlockDelta) {
      return null;
    }

    // Verify the payload type field — guards against mismatched chunks or
    // providers that omit the SSE event: line.
    if (x['type'] != _kContentBlockDelta) {
      return null;
    }

    // The delta object carries both the delta type and the text value.
    final delta = x['delta'];
    if (delta is! Map) {
      return null;
    }

    // Only text_delta carries actual text content; image_delta and others
    // are not relevant for text streaming.
    if (delta['type'] != _kTextDelta) {
      return null;
    }

    final text = delta['text'];
    if (text is! String || text.isEmpty) {
      return null;
    }

    return text;
  }
}
