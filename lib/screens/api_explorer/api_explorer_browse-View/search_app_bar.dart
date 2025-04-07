import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class SearchAppBar extends ConsumerWidget {
  final TextEditingController searchController;
  final VoidCallback? onSearchCleared;

  const SearchAppBar({
    super.key,
    required this.searchController,
    this.onSearchCleared,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Title(),
              const SizedBox(height: 12),
              _SearchField(
                searchController: searchController,
                ref: ref,
                onCleared: onSearchCleared,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'API Templates',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  final TextEditingController searchController;
  final WidgetRef ref;
  final VoidCallback? onCleared;

  const _SearchField({
    required this.searchController,
    required this.ref,
    this.onCleared,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: kSegmentedTabHeight, // Using your constant for height
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search APIs...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: searchController,
            builder: (context, value, child) {
              return AnimatedSwitcher(
                duration: kTabAnimationDuration, //
                child: value.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 20,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          searchController.clear();
                          ref.read(apiSearchQueryProvider.notifier).state = '';
                          onCleared?.call();
                        },
                      ),
              );
            },
          ),
          filled: true,
          fillColor: isDark 
              ? theme.colorScheme.surfaceVariant.withOpacity(0.4)
              : theme.colorScheme.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Matching your card radius
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5,
            ),
          ),
          constraints: const BoxConstraints(
            minHeight: kSegmentedTabHeight,
          ),
        ),
        style: theme.textTheme.bodyMedium,
        onChanged: (value) => ref.read(apiSearchQueryProvider.notifier).state = value,
      ),
    );
  }
}