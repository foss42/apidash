import 'package:better_networking/better_networking.dart';
import '../models/models.dart';

abstract class ModelProvider {
  ModelRequestData get defaultRequestData => throw UnimplementedError();

  HttpRequestModel? createRequest(ModelRequestData? requestData) {
    throw UnimplementedError();
  }

  String? outputFormatter(Map x) {
    throw UnimplementedError();
  }

  String? streamOutputFormatter(Map x) {
    throw UnimplementedError();
  }
}
