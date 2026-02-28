import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/editor.dart';

class HisAIRequestPromptSection extends ConsumerWidget {
  const HisAIRequestPromptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final selectedHistoryModel =
        ref.watch(selectedHistoryRequestModelProvider)!;
    final aiReqM = selectedHistoryModel.aiRequestModel;
    if (aiReqM == null) {
      return kSizedBoxEmpty;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'System Prompt',
            ),
          ),
          kVSpacer10(ds.scaleFactor),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel.historyId}-aireq-sysprompt-body"),
                fieldKey:
                    "${selectedHistoryModel.historyId}-aireq-sysprompt-body",
                initialValue: aiReqM.systemPrompt,
                readOnly: true,
              ),
            ),
          ),
          SizedBox(height: 10*ds.scaleFactor),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'User Prompt / Input',
            ),
          ),
          kVSpacer10(ds.scaleFactor),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel.historyId}-aireq-userprompt-body"),
                fieldKey:
                    "${selectedHistoryModel.historyId}-aireq-userprompt-body",
                initialValue: aiReqM.userPrompt,
                readOnly: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HisAIRequestAuthorizationSection extends ConsumerWidget {
  const HisAIRequestAuthorizationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel =
        ref.watch(selectedHistoryRequestModelProvider)!;
    final aiReqM = selectedHistoryModel.aiRequestModel;
    if (aiReqM == null) {
      return kSizedBoxEmpty;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel.historyId}-aireq-authvalue-body"),
                fieldKey:
                    "${selectedHistoryModel.historyId}-aireq-authvalue-body",
                initialValue: aiReqM.apiKey,
                readOnly: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HisAIRequestConfigSection extends ConsumerWidget {
  const HisAIRequestConfigSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final selectedHistoryModel =
        ref.watch(selectedHistoryRequestModelProvider)!;
    final aiReqM = selectedHistoryModel.aiRequestModel;
    if (aiReqM == null) {
      return kSizedBoxEmpty;
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        key: ValueKey(selectedHistoryModel.historyId),
        children: [
          ...aiReqM.modelConfigs.map(
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
                        readonly: true,
                        configuration: el,
                        onConfigUpdated: (x) {},
                      ),
                    ConfigType.numeric => AIConfigField(
                        readonly: true,
                        configuration: el,
                        onConfigUpdated: (x) {},
                        numeric: true,
                      ),
                    ConfigType.text => AIConfigField(
                        readonly: true,
                        configuration: el,
                        onConfigUpdated: (x) {},
                      ),
                    ConfigType.slider => AIConfigSlider(
                        readonly: true,
                        configuration: el,
                        onSliderUpdated: (x) {},
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
