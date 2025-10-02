import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import '../services/services.dart';

final promptBuilderProvider = Provider<PromptBuilder>((ref) {
  return PromptBuilder();
});

final urlEnvServiceProvider = Provider<UrlEnvService>((ref) {
  return UrlEnvService();
});

final requestApplyServiceProvider = Provider<RequestApplyService>((ref) {
  return RequestApplyService(urlEnv: ref.read(urlEnvServiceProvider));
});

final autoFixServiceProvider = Provider<AutoFixService>((ref) {
  final collection = ref.read(collectionStateNotifierProvider.notifier);
  final urlEnv = ref.read(urlEnvServiceProvider);
  return AutoFixService(
    requestApply: ref.read(requestApplyServiceProvider),
    updateSelected: ({
      required String id,
      HTTPVerb? method,
      String? url,
      List<NameValueModel>? headers,
      List<bool>? isHeaderEnabledList,
      String? body,
      ContentType? bodyContentType,
      List<FormDataModel>? formData,
      List<NameValueModel>? params,
      List<bool>? isParamEnabledList,
      String? postRequestScript,
    }) {
      collection.update(
        id: id,
        method: method,
        url: url,
        headers: headers,
        isHeaderEnabledList: isHeaderEnabledList,
        body: body,
        bodyContentType: bodyContentType,
        formData: formData,
        params: params,
        isParamEnabledList: isParamEnabledList,
        postRequestScript: postRequestScript,
      );
    },
    addNewRequest: (model, {name}) =>
        collection.addRequestModel(model, name: name ?? 'New Request'),
    readCurrentRequestId: () => ref.read(selectedRequestModelProvider)?.id,
    ensureBaseUrl: (baseUrl) => urlEnv.ensureBaseUrlEnv(
      baseUrl,
      readEnvs: () => ref.read(environmentsStateNotifierProvider),
      readActiveEnvId: () => ref.read(activeEnvironmentIdStateProvider),
      updateEnv: (id, {values}) => ref
          .read(environmentsStateNotifierProvider.notifier)
          .updateEnvironment(id, values: values),
    ),
    readCurrentRequest: () => ref.read(selectedRequestModelProvider),
  );
});
