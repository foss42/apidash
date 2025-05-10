import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/templates_service.dart';

class TemplatesState {
  final List<ApiTemplate> templates;
  final bool isLoading;
  final String? error;
  final bool isCached;

  TemplatesState({
    this.templates = const [],
    this.isLoading = false,
    this.error,
    this.isCached = false,
  });

  TemplatesState copyWith({
    List<ApiTemplate>? templates,
    bool? isLoading,
    String? error,
    bool? isCached,
  }) {
    return TemplatesState(
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isCached: isCached ?? this.isCached,
    );
  }
}

class TemplatesNotifier extends StateNotifier<TemplatesState> {
  TemplatesNotifier() : super(TemplatesState()) {
    loadInitialTemplates();
  }

  Future<void> loadInitialTemplates() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final templates = await TemplatesService.loadTemplates();
      final isCached = await TemplatesService.hasCachedTemplates();
      state = state.copyWith(
        templates: templates,
        isLoading: false,
        isCached: isCached,
      );
    } catch (e) {
      state = state.copyWith(
        templates: [],
        isLoading: false,
        error: 'Failed to load templates: $e',
      );
    }
  }

  Future<void> fetchTemplatesFromGitHub() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final templates = await TemplatesService.fetchTemplatesFromGitHub();
      state = state.copyWith(
        templates: templates,
        isLoading: false,
        isCached: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch templates: $e',
      );
    }
  }
}

final templatesProvider = StateNotifierProvider<TemplatesNotifier, TemplatesState>(
  (ref) => TemplatesNotifier(),
);