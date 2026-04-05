import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';

class GrpcMetadataTab extends ConsumerStatefulWidget {
  const GrpcMetadataTab({super.key});

  @override
  ConsumerState<GrpcMetadataTab> createState() => _GrpcMetadataTabState();
}

class _GrpcMetadataTabState extends ConsumerState<GrpcMetadataTab> {
  late int seed;
  final random = Random.secure();

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final grpcModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.grpcRequestModel));
    final metadata = grpcModel?.metadata ?? [];

    return Padding(
      padding: kP8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Request Metadata",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                tooltip: "Add metadata entry",
                onPressed: () {
                  final updated = [
                    ...metadata,
                    const GrpcMetadataEntry(key: '', value: ''),
                  ];
                  ref.read(collectionStateNotifierProvider.notifier).update(
                        grpcRequestModel:
                            grpcModel?.copyWith(metadata: updated),
                      );
                  setState(() => seed = random.nextInt(kRandMax));
                },
              ),
            ],
          ),
          kVSpacer5,
          Expanded(
            child: metadata.isEmpty
                ? Center(
                    child: Text(
                      "No metadata entries.\nClick + to add gRPC metadata (headers).",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: metadata.length,
                    itemBuilder: (context, index) {
                      final entry = metadata[index];
                      return Padding(
                        padding: kPv2,
                        child: Row(
                          children: [
                            Expanded(
                              child: EnvironmentTriggerField(
                                keyId:
                                    "grpc-meta-key-$selectedId-$index-$seed",
                                initialValue: entry.key,
                                style: kCodeStyle.copyWith(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: "Key",
                                  hintStyle: kCodeStyle.copyWith(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: kBorderRadius6,
                                  ),
                                ),
                                onChanged: (value) {
                                  final updated = [...metadata];
                                  updated[index] =
                                      entry.copyWith(key: value);
                                  ref
                                      .read(collectionStateNotifierProvider
                                          .notifier)
                                      .update(
                                        grpcRequestModel: grpcModel
                                            ?.copyWith(metadata: updated),
                                      );
                                },
                                optionsWidthFactor: 1,
                              ),
                            ),
                            kHSpacer8,
                            Expanded(
                              child: EnvironmentTriggerField(
                                keyId:
                                    "grpc-meta-val-$selectedId-$index-$seed",
                                initialValue: entry.value,
                                style: kCodeStyle.copyWith(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: "Value",
                                  hintStyle: kCodeStyle.copyWith(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: kBorderRadius6,
                                  ),
                                ),
                                onChanged: (value) {
                                  final updated = [...metadata];
                                  updated[index] =
                                      entry.copyWith(value: value);
                                  ref
                                      .read(collectionStateNotifierProvider
                                          .notifier)
                                      .update(
                                        grpcRequestModel: grpcModel
                                            ?.copyWith(metadata: updated),
                                      );
                                },
                                optionsWidthFactor: 1,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  size: 16),
                              tooltip: "Remove",
                              onPressed: () {
                                final updated = [...metadata];
                                updated.removeAt(index);
                                ref
                                    .read(collectionStateNotifierProvider
                                        .notifier)
                                    .update(
                                      grpcRequestModel: grpcModel
                                          ?.copyWith(metadata: updated),
                                    );
                                setState(
                                    () => seed = random.nextInt(kRandMax));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
