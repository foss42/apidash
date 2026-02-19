import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestConfigSection extends ConsumerWidget {
  const AIRequestConfigSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final selectedId = ref.watch(selectedIdStateProvider);
    final modelConfigs = ref.watch(selectedRequestModelProvider
        .select((value) => value?.aiRequestModel?.modelConfigs));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);
    final aiReqM = requestModel?.aiRequestModel;
    if (aiReqM == null || modelConfigs == null) {
      return kSizedBoxEmpty;
    }

    updateRequestModel(ModelConfig modelConfig) {
      final aiRequestModel = ref
          .read(collectionStateNotifierProvider.notifier)
          .getRequestModel(selectedId)
          ?.aiRequestModel;
      final idx = aiRequestModel?.getModelConfigIdx(modelConfig.id);
      if (idx != null && aiRequestModel != null) {
        var l = [...aiRequestModel.modelConfigs];
        l[idx] = modelConfig;
        ref.read(collectionStateNotifierProvider.notifier).update(
              aiRequestModel: aiRequestModel.copyWith(modelConfigs: l),
            );
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        key: ValueKey(selectedId),
        children: [
          ...modelConfigs.map(
            (el) => ListTile(
              title: Text(el.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    el.description,
                  ),
                  SizedBox(height: 5*ds.scaleFactor),
                  switch (el.type) {
                    ConfigType.boolean => AIConfigBool(
                        configuration: el,
                        onConfigUpdated: (x) {
                          updateRequestModel(x);
                        },
                      ),
                    ConfigType.numeric => AIConfigField(
                        configuration: el,
                        onConfigUpdated: (x) {
                          updateRequestModel(x);
                        },
                        numeric: true,
                      ),
                    ConfigType.text => AIConfigField(
                        configuration: el,
                        onConfigUpdated: (x) {
                          updateRequestModel(x);
                        },
                      ),
                    ConfigType.slider => AIConfigSlider(
                        configuration: el,
                        onSliderUpdated: (x) {
                          updateRequestModel(x);
                        },
                      ),
                  },
                  SizedBox(height: 10*ds.scaleFactor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
