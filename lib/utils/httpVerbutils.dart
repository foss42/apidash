import 'package:apidash_core/consts.dart';

class HttpVerbUtils {
  static HTTPVerb parseHttpMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET': return HTTPVerb.get;
      case 'POST': return HTTPVerb.post;
      case 'PUT': return HTTPVerb.put;
      case 'DELETE': return HTTPVerb.delete;
      case 'PATCH': return HTTPVerb.patch;
      case 'HEAD': return HTTPVerb.head;
      default: return HTTPVerb.get;
    }
  }

  static String httpVerbToString(HTTPVerb verb) {
    return verb.toString().split('.').last.toUpperCase();
  }
}