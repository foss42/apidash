import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'providers.dart';
import '../models/models.dart';
import '../services/services.dart' show hiveHandler, HiveHandler;
import '../utils/utils.dart'
    show getNewUuid, collectionToHAR, substituteHttpRequestModel;

final selectedIdStateProvider = StateProvider<String?>((ref) => null);

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


final WebSocketManager webSocketManager = WebSocketManager();

final StateNotifierProvider<CollectionStateNotifier, Map<String, RequestModel>?>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier(
          ref,
          hiveHandler,
          webSocketManager
  ));

class CollectionStateNotifier
    extends StateNotifier<Map<String, RequestModel>?> {
  CollectionStateNotifier(
    this.ref,
    this.hiveHandler,
    this.webSocketManager
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
  final WebSocketManager webSocketManager;
  
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
      webSocketRequestModel: const WebSocketRequestModel(),
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

  void remove({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId!);
    cancelHttpRequest(rId);
    itemIds.remove(rId);
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
    map.remove(rId);
    state = map;
    unsave();
  }

  void clearResponse({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    if (rId == null || state?[rId] == null) return;
    var currentModel = state![rId]!;
    final newModel = currentModel.copyWith(
      responseStatus: null,
      message: null,
      httpResponseModel: null,
      isWorking: false,
      sendingTime: null,
    );
    var map = {...state!};
    map[rId] = newModel;
    state = map;
    unsave();
  }

  void duplicate({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId!);
    var currentModel = state![rId]!;
    final newModel = currentModel.copyWith(
      id: newId,
      name: "${currentModel.name} (copy)",
      requestTabIndex: 0,
      responseStatus: null,
      message: null,
      httpResponseModel: null,
      webSocketResponseModel: null,
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

  void update({
    String? id,
    HTTPVerb? method,
    APIType? apiType,
    String? url,
    String? name,
    String? description,
    int? requestTabIndex,
    List<NameValueModel>? headers,
    List<NameValueModel>? params,
    List<bool>? isHeaderEnabledList,
    List<bool>? isParamEnabledList,
    ContentType? bodyContentType,
    String? body,
    String? query,
    List<FormDataModel>? formData,
    int? responseStatus,
    String? message,
    String? webSocketMessage,
    ContentTypeWebSocket? contentType,
    HttpResponseModel? httpResponseModel,
    WebSocketResponseModel? webSocketResponseModel,
}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    if (rId == null) {
        debugPrint("Unable to update as Request Id is null");
        return;
    }

    var currentModel = state![rId]!;
    var currentApiType = apiType ?? currentModel.apiType;
    var currentHttpRequestModel = currentModel.httpRequestModel;
    final newHttpRequestModel = currentApiType == APIType.rest ||  currentApiType ==APIType.graphql ?
    currentHttpRequestModel?.copyWith(
            method: method ?? currentHttpRequestModel.method,
            url: url ?? currentHttpRequestModel.url,
            headers: headers ?? currentHttpRequestModel.headers,
            params: params ?? currentHttpRequestModel.params,
            isHeaderEnabledList: isHeaderEnabledList ??
                currentHttpRequestModel.isHeaderEnabledList,
            isParamEnabledList:
                isParamEnabledList ?? currentHttpRequestModel.isParamEnabledList,
            bodyContentType:
                bodyContentType ?? currentHttpRequestModel.bodyContentType,
            body: body ?? currentHttpRequestModel.body,
            query: query ?? currentHttpRequestModel.query,
            formData: formData ?? currentHttpRequestModel.formData,
        ) : currentHttpRequestModel;

    var currentWebSocketRequestModel = currentModel.webSocketRequestModel ?? const WebSocketRequestModel();

    final newWebSocketRequestModel = currentApiType == APIType.webSocket
        ? currentWebSocketRequestModel.copyWith(
            url: url ?? currentWebSocketRequestModel.url,
            contentType: contentType ?? currentWebSocketRequestModel.contentType,
            headers: headers ?? currentWebSocketRequestModel.headers,
            params: params ?? currentWebSocketRequestModel.params,
            isHeaderEnabledList: isHeaderEnabledList ??
                currentWebSocketRequestModel.isHeaderEnabledList,
            isParamEnabledList:
                isParamEnabledList ?? currentWebSocketRequestModel.isParamEnabledList,
            message: webSocketMessage ?? currentWebSocketRequestModel.message,
        )
        : currentWebSocketRequestModel;

    final newModel = currentModel.copyWith(
        apiType: apiType ?? currentModel.apiType,
        name: name ?? currentModel.name,
        description: description ?? currentModel.description,
        requestTabIndex: requestTabIndex ?? currentModel.requestTabIndex,
        httpRequestModel: newHttpRequestModel,
        webSocketRequestModel: newWebSocketRequestModel,
        responseStatus: responseStatus ?? currentModel.responseStatus,
        message: message ?? currentModel.message,
        httpResponseModel: httpResponseModel ?? currentModel.httpResponseModel,
    );

    var map = {...state!};
    map[rId] = newModel;
    state = map;
    unsave();
}


  Future<void> sendRequest() async {
    
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    final defaultUriScheme = ref.read(settingsProvider).defaultUriScheme;

    if (requestId == null || state == null) {
      return;
    }
    RequestModel? requestModel = state![requestId];

    if (requestModel?.httpRequestModel == null) {
      return;
    }

    APIType apiType = requestModel!.apiType;

    HttpRequestModel substitutedHttpRequestModel =
        getSubstitutedHttpRequestModel(requestModel.httpRequestModel!);

    // set current model's isWorking to true and update state
    var map = {...state!};
    map[requestId] = requestModel.copyWith(
      isWorking: true,
      sendingTime: DateTime.now(),
    );
    state = map;

    bool noSSL = ref.read(settingsProvider).isSSLDisabled;
    var responseRec = await sendHttpRequest(
      requestId,
      apiType,
      substitutedHttpRequestModel,
      defaultUriScheme: defaultUriScheme,
      noSSL: noSSL,
    );

    late final RequestModel newRequestModel;
    if (responseRec.$1 == null) {
      newRequestModel = requestModel.copyWith(
        responseStatus: -1,
        message: responseRec.$3,
        isWorking: false,
      );
    } else {
      final httpResponseModel = baseHttpResponseModel.fromResponse(
        response: responseRec.$1!,
        time: responseRec.$2!,
      );
      int statusCode = responseRec.$1!.statusCode;
      newRequestModel = requestModel.copyWith(
        responseStatus: statusCode,
        message: kResponseCodeReasons[statusCode],
        httpResponseModel: httpResponseModel,
        isWorking: false,
      );
      String newHistoryId = getNewUuid();
      HistoryRequestModel model = HistoryRequestModel(
        historyId: newHistoryId,
        metaData: HistoryMetaModel(
          historyId: newHistoryId,
          requestId: requestId,
          apiType: requestModel.apiType,
          name: requestModel.name,
          url: substitutedHttpRequestModel.url,
          method: substitutedHttpRequestModel.method,
          responseStatus: statusCode,
          timeStamp: DateTime.now(),
        ),
        httpRequestModel: substitutedHttpRequestModel,
        httpResponseModel: httpResponseModel,
        webSocketRequestModel:  newRequestModel.webSocketRequestModel!,
        webSocketResponseModel: newRequestModel.webSocketResponseModel ??const  WebSocketResponseModel() //still working
      );
      ref.read(historyMetaStateNotifier.notifier).addHistoryRequest(model);
    }

    // update state with response data
    map = {...state!};
    map[requestId] = newRequestModel;
    state = map;

    unsave();
  }

  void cancelRequest() {
    final id = ref.read(selectedIdStateProvider);
    cancelHttpRequest(id);
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
            : (state?[id]?.copyWith(httpResponseModel: null))?.toJson(),
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

  Future<void> sendFrames() async {
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
   

    if (requestId == null || state == null) {
      return;
    }
    RequestModel? requestModel = state![requestId];
    var currentWebSocketRequestModel = requestModel!.webSocketRequestModel;
    if (currentWebSocketRequestModel == null) {
      return;
    }

    
    String message = currentWebSocketRequestModel.message ?? '';
    late  (String?,DateTime?,String?) frame;
    if(currentWebSocketRequestModel.contentType == ContentTypeWebSocket.text){
      frame = await webSocketManager.sendText(requestId,message);
    }else if(currentWebSocketRequestModel.contentType == ContentTypeWebSocket.binary){
      frame = await webSocketManager.sendBinary(requestId,message);
    }
    
    late WebSocketResponseModel newWebSocketResponseModel;
    if(frame.$1 != null){
       newWebSocketResponseModel = requestModel.webSocketResponseModel!.copyWith(
      frames: [
        ...?requestModel.webSocketResponseModel?.frames,
        WebSocketFrameModel(
          id: getNewUuid(),
          message:frame.$1!,
          timeStamp: frame.$2,
          isSend: true
        ),  
      ],
    );
     
    }else if(frame.$3 != null){
      newWebSocketResponseModel = requestModel.webSocketResponseModel!.copyWith(
      frames: [
        ...?requestModel.webSocketResponseModel?.frames,
        WebSocketFrameModel(
          id: getNewUuid(),
          message:frame.$3!,
          timeStamp: null,
          isSend: true
        ),  
      ],
    );
      

    }

    
    

    final newRequestModel = requestModel.copyWith(
        webSocketResponseModel: newWebSocketResponseModel,
      );
   
    var map = {...state!};
    map[requestId] = newRequestModel;
    state = map;

    unsave();
  }


  Future<void> connect() async {
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    if (requestId == null || state == null) {
      return;
    }

    RequestModel? requestModel = state![requestId];

    if (requestModel?.webSocketRequestModel == null) {
      return;
    }

    bool isPinging = ref.read(settingsProvider).isPinging;
   
    webSocketManager.createWebSocketClient(requestId);
    if(isPinging){
      Duration durationPinging = Duration(milliseconds: ref.read(settingsProvider).pingInterval!);
      webSocketManager.setPingInterval(requestId,durationPinging);
    }else{
      webSocketManager.setPingInterval(requestId,null);
    }

    
    
    final webSocketRequestModel = requestModel!.webSocketRequestModel!;
    final url = webSocketRequestModel.url;
    final headers = webSocketRequestModel.headers;
    final params = webSocketRequestModel.params;
    var map = {...state!};

    map[requestId] = requestModel.copyWith(
      isWorking: true,
      sendingTime: DateTime.now(),
      webSocketResponseModel: const WebSocketResponseModel(),
    );

    requestModel = map[requestId];
    
    state = map;
    (String?,DateTime?) result = await webSocketManager.connect(requestId,url,headers,params);  

      
    
    if(result.$1 == kMsgConnected){
    map = {...state!};

    map[requestId] = requestModel!.copyWith(
      isWorking: false,
      responseStatus: 101,
      message: kResponseCodeReasons[101],
      webSocketRequestModel: webSocketRequestModel.copyWith(
        isConnected:true
      ),
      
    );

    
    requestModel = map[requestId];  
    state = map;
    
    webSocketManager.listen(
      requestId,
      (message) async{
        
        map = {...state!};
        requestModel = map[requestId];  

        
        WebSocketResponseModel webSocketResponseModel = requestModel!.webSocketResponseModel!;
       
        WebSocketResponseModel newWebSocketResponseModel = webSocketResponseModel.copyWith(
          frames: [...webSocketResponseModel.frames, WebSocketFrameModel(
            id: getNewUuid(),
            message: message,
            timeStamp:DateTime.now(),
            isSend: false
          )]
        );
        var newRequestModel = requestModel!.copyWith(
          isWorking: false,
          responseStatus: 101,
          webSocketResponseModel: newWebSocketResponseModel,
        );
       

     
      map[requestId] = newRequestModel;

      state = map;
      
      },
      onError: (error) async{
        var statusCode = error.statusCode;
        map = {...state!};
        requestModel = map[requestId];  
        WebSocketResponseModel webSocketResponseModel = requestModel!.webSocketResponseModel!;
        WebSocketResponseModel newWebSocketResponseModel = webSocketResponseModel.copyWith(
          frames: [...webSocketResponseModel.frames, WebSocketFrameModel(
            id: getNewUuid(),
            message: error.toString(),
            timeStamp:DateTime.now(),
            isSend: true
          )]
        );
        var newRequestModel = requestModel!.copyWith(
          responseStatus: statusCode,
          message: kResponseCodeReasons[statusCode],
          webSocketResponseModel: newWebSocketResponseModel,
        );
        map[requestId] = newRequestModel;
        state = map;
        
      },
      onDone: () async{
         map = {...state!};
        requestModel = map[requestId];  
        WebSocketRequestModel webSocketRequestModel = requestModel!.webSocketRequestModel!;
        WebSocketRequestModel newWebSocketRequestModel = webSocketRequestModel.copyWith(
          isConnected: false
        );
        var newRequestModel = requestModel!.copyWith(
          webSocketRequestModel: newWebSocketRequestModel,
        );
        map[requestId] = newRequestModel;
        state = map;
        
        
      },
      cancelOnError: false,
    );
  }else{
    map = {...state!};
    WebSocketResponseModel newWebSocketResponseModel = requestModel!.webSocketResponseModel!.copyWith(
          frames: [...requestModel.webSocketResponseModel!.frames, WebSocketFrameModel(
            id: getNewUuid(),
            message: result.$1!,
            timeStamp:DateTime.now(),
            isSend: false
    )]);
    map[requestId] = requestModel.copyWith(
      isWorking: false,
      responseStatus: 1002,
      message: kResponseCodeReasons[1002],
      sendingTime: result.$2,
      webSocketResponseModel: newWebSocketResponseModel,
    );
    
    state = map;
  }
  }


  Future<void> disconnect() async {
    final requestId = ref.read(selectedIdStateProvider);
    if (requestId == null || state == null) {
      return;
    }

    webSocketManager.disconnect(requestId);
    
    
    
      RequestModel? requestModel = state![requestId];
       WebSocketRequestModel webSocketRequestModel = requestModel!.webSocketRequestModel!;
        WebSocketRequestModel newWebSocketRequestModel = webSocketRequestModel.copyWith(
          isConnected: false
        );

    var newRequestModel = requestModel.copyWith(
        webSocketRequestModel: newWebSocketRequestModel,
    );
       

    var map = {...state!};
    map[requestId] = newRequestModel;
    state = map;

  }


  void deleteAllFrames(){ 
    final requestId = ref.read(selectedIdStateProvider);
    if (requestId == null || state == null) {
      return;
    }
    RequestModel? requestModel = state![requestId];
    WebSocketResponseModel webSocketResponseModel = requestModel!.webSocketResponseModel!;
    WebSocketResponseModel newWebSocketResponseModel = webSocketResponseModel.copyWith(
          frames: [],
    );

    var newRequestModel = requestModel.copyWith(
          webSocketResponseModel: newWebSocketResponseModel,
    );
     var map = {...state!};
    map[requestId] = newRequestModel;
    state = map;
 }

  void deleteFrame(String id){
    final requestId = ref.read(selectedIdStateProvider);
    if (requestId == null || state == null) {
      return;
    }
    RequestModel? requestModel = state![requestId];
    if (requestModel == null || state == null) {
      return;
    }
    WebSocketResponseModel webSocketResponseModel = requestModel.webSocketResponseModel!;
    List<WebSocketFrameModel> newFrames = requestModel.webSocketResponseModel!.frames.where((element) => element.id != id).toList();
    WebSocketResponseModel newWebSocketResponseModel = webSocketResponseModel.copyWith(
          frames: newFrames,
    );

    var newRequestModel = requestModel.copyWith(
          webSocketResponseModel: newWebSocketResponseModel,
    );
     var map = {...state!};
    map[requestId] = newRequestModel;
    state = map;

  }
    

}
