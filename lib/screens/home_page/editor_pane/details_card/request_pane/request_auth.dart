import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/auth/request_api_key_auth.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditRequestAuth extends ConsumerWidget {
  const EditRequestAuth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
     final authType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.httpRequestModel?.authType));

    return Column(
      children: [
        (apiType == APIType.rest)
            ? const SizedBox(
                height: kHeaderHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select Auth Type:",
                    ),
                    DropdownButtonAuthType(),
                  ],
                ),
              )
            : kSizedBoxEmpty,
        switch (authType) {
          AuthType.bearerToken =>  ApiAuthWidget(),
          AuthType.None =>Center(child: Text("Choose an Authentication"),),
          _ => Center(child: Text("Choose an Authentication"),)
        }   
       ],
    );
  }
}

class DropdownButtonAuthType extends ConsumerWidget {
  const DropdownButtonAuthType({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final requestBodyAuthType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.authType));
    return DropdownButtonAuthTypeSelection(
      authType: requestBodyAuthType,
      onChanged: (AuthType? value) {
              ref
             .read(collectionStateNotifierProvider.notifier)
             .update(authType: value);
      },
    );
  }
}
