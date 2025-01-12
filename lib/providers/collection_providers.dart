import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_core/models/graphql_response_model.dart';
import 'package:apidash_core/services/graphql_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'providers.dart';
import '../models/models.dart';
import '../services/services.dart' show hiveHandler, HiveHandler;
import '../utils/utils.dart'
    show collectionToHAR, getNewUuid, substituteHttpRequestModel, substitutegraphqlRequestModel;

final selectedIdStateProvider = StateProvider<String?>((ref) => null);
final selectedAPITypeProvider = StateProvider<APIType?>((ref) => APIType.rest);

final selectedRequestModelProvider = StateProvider<RequestModel?>((ref) {
  final selectedId = ref.watch(selectedIdStateProvider);
  final collection = ref.watch(collectionStateNotifierProvider);
  if (selectedId == null || collection == null) {
    return null;
  } else {
    return collection[selectedId];
  }
});

final requestSequenceProvider = StateProvider<List<String>>((ref) {
  var ids = hiveHandler.getIds();
  return ids ?? [];
});

final httpClientManager = HttpClientManager();

final StateNotifierProvider<CollectionStateNotifier, Map<String, RequestModel>?>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier(
          ref,
          hiveHandler,
          httpClientManager,
        ));

class CollectionStateNotifier
    extends StateNotifier<Map<String, RequestModel>?> {
  CollectionStateNotifier(
    this.ref,
    this.hiveHandler,
    this.httpClientManager,
  ) : super(null) {
    var status = loadData();
    Future.microtask(() {
      if (status) {
        ref.read(requestSequenceProvider.notifier).state = [
          state!.keys.first,
        ];
      }
      ref.read(selectedIdStateProvider.notifier).state =
          ref.read(requestSequenceProvider)[0];
    });
  }

  final Ref ref;
  final HiveHandler hiveHandler;
  final baseHttpResponseModel = const HttpResponseModel();
  final basegraphqlResponseModel = const GraphqlResponseModel();
  final HttpClientManager httpClientManager;

  bool hasId(String id) => state?.keys.contains(id) ?? false;

  RequestModel? getRequestModel(String id) {
    return state?[id];
  }

  void unsave() {
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  void add() {
    final id = getNewUuid();
    final newRequestModel = RequestModel(
      id: id,
      httpRequestModel: const HttpRequestModel(),
      graphqlRequestModel: const GraphqlRequestModel(),
    );
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
    ref
        .read(requestSequenceProvider.notifier)
        .update((state) => [id, ...state]);
    ref.read(selectedIdStateProvider.notifier).state = newRequestModel.id;
    unsave();
  }

  void addRequestModel(
    HttpRequestModel httpRequestModel, {
    String? name,
  }) {
    final id = getNewUuid();
    final newRequestModel = RequestModel(
      id: id,
      name: name ?? "",
      httpRequestModel: httpRequestModel,
    );
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
    ref
        .read(requestSequenceProvider.notifier)
        .update((state) => [id, ...state]);
    ref.read(selectedIdStateProvider.notifier).state = newRequestModel.id;
    unsave();
  }

  void reorder(int oldIdx, int newIdx) {
    var itemIds = ref.read(requestSequenceProvider);
    final itemId = itemIds.removeAt(oldIdx);
    itemIds.insert(newIdx, itemId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    unsave();
  }

  void remove(String id) {
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(id);
    itemIds.remove(id);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];

    String? newId;
    if (idx == 0 && itemIds.isNotEmpty) {
      newId = itemIds[0];
    } else if (itemIds.length > 1) {
      newId = itemIds[idx - 1];
    } else {
      newId = null;
    }

    ref.read(selectedIdStateProvider.notifier).state = newId;

    var map = {...state!};
    map.remove(id);
    state = map;
    unsave();
  }

  void clearResponse(String? id) {
    if (id == null || state?[id] == null) return;
    var currentModel = state![id]!;
    final newModel = currentModel.copyWith(
      responseStatus: null,
      message: null,
      httpResponseModel: null,
      isWorking: false,
      sendingTime: null,
    );
    var map = {...state!};
    map[id] = newModel;
    state = map;
    unsave();
  }

  void duplicate(String id) {
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(id);
    var currentModel = state![id]!;
    final newModel = currentModel.copyWith(
      id: newId,
      name: "${currentModel.name} (copy)",
      requestTabIndex: 0,
      responseStatus: null,
      message: null,
      httpResponseModel: null,
      graphqlResponseModel: null,
      isWorking: false,
      sendingTime: null,
    );

    itemIds.insert(idx + 1, newId);
    var map = {...state!};
    map[newId] = newModel;
    state = map;

    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    ref.read(selectedIdStateProvider.notifier).state = newId;
    unsave();
  }

  void duplicateFromHistory(HistoryRequestModel historyRequestModel) {
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    var currentModel = historyRequestModel;
    final newModel = RequestModel(
      id: newId,
      name: "${currentModel.metaData.name} (history)",
      apiType: currentModel.metaData.apiType,
      httpRequestModel: currentModel.httpRequestModel,
      responseStatus: currentModel.metaData.responseStatus,
      message: kResponseCodeReasons[currentModel.metaData.responseStatus],
      httpResponseModel: currentModel.httpResponseModel,
      isWorking: false,
      sendingTime: null,
    );

    itemIds.insert(0, newId);
    var map = {...state!};
    map[newId] = newModel;
    state = map;

    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    ref.read(selectedIdStateProvider.notifier).state = newId;
    unsave();
  }

  void update(
    String id, {
    HTTPVerb? method,
    APIType? apiType,
    String? httpUrl,
    String? name,
    String? description,
    int? requestTabIndex,
    List<NameValueModel>? headers,
    List<NameValueModel>? params,
    String? graphqlUrl,
    List<bool>? isHeaderEnabledList,
    List<bool>? isParamEnabledList,
    ContentType? bodyContentType,
    String? body,
    List<FormDataModel>? formData,
    List<NameValueModel>? graphqlVariables,
    List<bool>? isgraphqlVariablesEnabledList,
    String? query,
    int? responseStatus,
    String? message,
    HttpResponseModel? httpResponseModel,
    GraphqlResponseModel? graphqlResponseModel
  }) {
    print("entered update");
    print("inside update ${bodyContentType}");
     print("inside update graphqlvariable ${graphqlVariables}");
    var currentModel = state![id]!;
    var currentHttpRequestModel = currentModel.httpRequestModel;
    var currentGraphqlRequestModel = currentModel.graphqlRequestModel;
  

    //need to make changes when i change from http to rest and vice versa
    final newModel = currentModel.copyWith(
      name: name ?? currentModel.name,
      description: description ?? currentModel.description,
      requestTabIndex: requestTabIndex ?? currentModel.requestTabIndex,
      apiType: apiType ?? currentModel.apiType,
      httpRequestModel: currentHttpRequestModel?.copyWith(
        method: method ?? currentHttpRequestModel.method,
        url: httpUrl ?? currentHttpRequestModel.url,
        headers: headers ?? currentHttpRequestModel.headers,
        params: params ?? currentHttpRequestModel.params,
        isHeaderEnabledList:
            isHeaderEnabledList ?? currentHttpRequestModel.isHeaderEnabledList,
        isParamEnabledList:
            isParamEnabledList ?? currentHttpRequestModel.isParamEnabledList,
        bodyContentType:
            bodyContentType ?? currentHttpRequestModel.bodyContentType,
        body: body ?? currentHttpRequestModel.body,
        formData: formData ?? currentHttpRequestModel.formData,
      ),
      graphqlRequestModel: currentGraphqlRequestModel?.copyWith(
        url: graphqlUrl ?? currentGraphqlRequestModel.url,
        headers: headers ?? currentGraphqlRequestModel.headers,
        graphqlVariables: graphqlVariables ?? currentGraphqlRequestModel.graphqlVariables,
        isHeaderEnabledList:
            isHeaderEnabledList ?? currentGraphqlRequestModel.isHeaderEnabledList,
        isgraphqlVariablesEnabledList:
            isgraphqlVariablesEnabledList ?? currentGraphqlRequestModel.isgraphqlVariablesEnabledList,
        query: query ?? currentGraphqlRequestModel.query,
        
      ),
      responseStatus: responseStatus ?? currentModel.responseStatus,
      message: message ?? currentModel.message,
      httpResponseModel: httpResponseModel ?? currentModel.httpResponseModel,
      graphqlResponseModel: graphqlResponseModel ?? currentModel.graphqlResponseModel,
    );
    print("after copywith");
    var map = {...state!};
    map[id] = newModel;
    state = map;
    unsave();
    
  }
  

  Future<void> sendRequest() async {
    print("sending");
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    final defaultUriScheme = ref.read(settingsProvider).defaultUriScheme;

    if (requestId == null || state == null) {
      print("entered null states for reqid and state");
      return;
    }
    RequestModel? requestModel = state![requestId];

    if (requestModel?.httpRequestModel == null && requestModel?.graphqlRequestModel==null) {
      print("entered http and graphql");
      return;
    }

    HttpRequestModel substitutedHttpRequestModel =
        getSubstitutedHttpRequestModel(requestModel!.httpRequestModel!);
    print("after susbstituted http");
    GraphqlRequestModel substitutedgraphqlRequestModel = 
         getSubstitutedgraphqlRequestModel(requestModel.graphqlRequestModel!);
    print("After sustitution");
    // set current model's isWorking to true and update state
    var map = {...state!};
    map[requestId] = requestModel.copyWith(
      isWorking: true,
      sendingTime: DateTime.now(),
    );
    state = map;

    var typeAPI = ref.read(selectedAPITypeProvider); 
      
    
  bool noSSL = ref.read(settingsProvider).isSSLDisabled;

  late  (dynamic, Duration?, String?)? responseRec;
   if(typeAPI == APIType.rest){
    print("entered typeApi rest");
    responseRec = await request(
      requestId,
      substitutedHttpRequestModel,
      defaultUriScheme: defaultUriScheme,
      noSSL: noSSL,
    );

   }else{
      responseRec = await graphRequest(requestId, substitutedgraphqlRequestModel);
      
   }
    

    late final RequestModel newRequestModel;
    if (responseRec.$1 == null) {
      newRequestModel = requestModel.copyWith(
        responseStatus: -1,
        message: responseRec.$3,
        isWorking: false,
      );
    } else {
      print("entered else inside sendrequest");
      
        print("repsonserec2:${responseRec.$2}");
        final httpResponseModel = typeAPI == APIType.rest
        ? baseHttpResponseModel.fromResponse(
            response: responseRec.$1!,
            time: responseRec.$2!,
          )
        : baseHttpResponseModel;
    print("after http ");
    print("repsonserec1:${responseRec.$1}");
   
    final graphqlResponseModel = typeAPI == APIType.graphql
        ? basegraphqlResponseModel.fromResponse(
            response: responseRec.$1!,
            time:responseRec.$2!,
            graphqlRequestModel: substitutedgraphqlRequestModel,
          )
        : basegraphqlResponseModel;
      
      print("after assigning");

      
      print("printing graphqlResponseModel ${graphqlResponseModel}");
      late int statusCode;
      if(typeAPI == APIType.rest){
          statusCode = responseRec.$1!.statusCode;
      }else{
        statusCode = responseRec.$1!.context.entry<HttpLinkResponseContext>()?.statusCode ;

      }
     
      newRequestModel = requestModel.copyWith(
        responseStatus: statusCode,
        message: kResponseCodeReasons[statusCode],
        httpResponseModel: typeAPI == APIType.rest ? httpResponseModel : baseHttpResponseModel,
        graphqlResponseModel: typeAPI == APIType.graphql ? graphqlResponseModel : basegraphqlResponseModel ,
        isWorking: false,
      );
      
      String newHistoryId = getNewUuid();
      HistoryRequestModel model = HistoryRequestModel(
        historyId: newHistoryId,
        metaData: HistoryMetaModel(
          historyId: newHistoryId,
          requestId: requestId,
          name: requestModel.name,
          apiType: requestModel.apiType,
          url: substitutedHttpRequestModel.url,
          method: substitutedHttpRequestModel.method,
          responseStatus: statusCode,
          timeStamp: DateTime.now(),
        ),
        httpRequestModel: substitutedHttpRequestModel,
      
        httpResponseModel: typeAPI == APIType.rest ? httpResponseModel : baseHttpResponseModel,
      
      );
      ref.read(historyMetaStateNotifier.notifier).addHistoryRequest(model);
      
    }

    // update state with response data
    map = {...state!};
    map[requestId] = newRequestModel;
    state = map;

    unsave();
    print("end of send request");
  }

  void cancelRequest() {
    final id = ref.read(selectedIdStateProvider);
    httpClientManager.cancelRequest(id);
    unsave();
  }

  Future<void> clearData() async {
    ref.read(clearDataStateProvider.notifier).state = true;
    ref.read(selectedIdStateProvider.notifier).state = null;
    await hiveHandler.clear();
    ref.read(clearDataStateProvider.notifier).state = false;
    ref.read(requestSequenceProvider.notifier).state = [];
    state = {};
    unsave();
  }

  bool loadData() {
    var ids = hiveHandler.getIds();
    if (ids == null || ids.length == 0) {
      String newId = getNewUuid();
      state = {
        newId: RequestModel(
          id: newId,
          httpRequestModel: const HttpRequestModel(),
          graphqlRequestModel: const GraphqlRequestModel(),
          
        ),
      };
      return true;
    } else {
      Map<String, RequestModel> data = {};
      for (var id in ids) {
        var jsonModel = hiveHandler.getRequestModel(id);
        if (jsonModel != null) {
          var jsonMap = Map<String, Object?>.from(jsonModel);
          var requestModel = RequestModel.fromJson(jsonMap);
          if (requestModel.httpRequestModel == null) {
            requestModel = requestModel.copyWith(
              httpRequestModel: const HttpRequestModel(),
            );
          }
          if(requestModel.graphqlRequestModel == null){
            requestModel=requestModel.copyWith(
              graphqlRequestModel:const GraphqlRequestModel() 
            );
            
          }
          data[id] = requestModel;
        }
      }
      state = data;
      return false;
    }
  }

  Future<void> saveData() async {
    ref.read(saveDataStateProvider.notifier).state = true;
    final saveResponse = ref.read(settingsProvider).saveResponses;
    final ids = ref.read(requestSequenceProvider);
    await hiveHandler.setIds(ids);
    for (var id in ids) {
      await hiveHandler.setRequestModel(
        id,
        saveResponse
            ? (state?[id])?.toJson()
            : (state?[id]?.copyWith(httpResponseModel: null,graphqlRequestModel: null))?.toJson(),
      );
    }
    await hiveHandler.removeUnused();
    ref.read(saveDataStateProvider.notifier).state = false;
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }

  Future<Map<String, dynamic>> exportDataToHAR() async {
    var result = await collectionToHAR(state?.values.toList());
    return result;
    // return {
    //   "data": state!.map((e) => e.toJson(includeResponse: false)).toList()
    // };
  }

  HttpRequestModel getSubstitutedHttpRequestModel(
      HttpRequestModel httpRequestModel) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdStateProvider);

    return substituteHttpRequestModel(
      httpRequestModel,
      envMap,
      activeEnvId,
    );
  }
  GraphqlRequestModel getSubstitutedgraphqlRequestModel(
      GraphqlRequestModel graphqlRequestModel) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdStateProvider);

    return substitutegraphqlRequestModel(
      graphqlRequestModel,
      envMap,
      activeEnvId,
    );
  }
}
