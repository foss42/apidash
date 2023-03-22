import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';
import '../consts.dart';

String getRequestTitleFromUrl(String? url) {
  if (url == null || url.trim() == "") {
    return "untitled";
  }
  if (url.contains("://")) {
    String rem = url.split("://")[1];
    if (rem.trim() == "") {
      return "untitled";
    }
    return rem;
  }
  return url;
}

(List<ResponseBodyView>, String?)  getResponseBodyViewOptions(MediaType mediaType){
  var type = mediaType.type;
  var subtype = mediaType.subtype;
  //print(mediaType);
  if(kResponseBodyViewOptions.containsKey(type)){
    if(subtype.contains(kSubTypeJson)){
      subtype = kSubTypeJson;
    }
    if(subtype.contains(kSubTypeXml)){
      subtype = kSubTypeXml;
    }
    if (kResponseBodyViewOptions[type]!.containsKey(subtype)){
       return (kResponseBodyViewOptions[type]![subtype]!, kCodeHighlighterMap[subtype] ?? subtype);
    }
    return (kResponseBodyViewOptions[type]![kSubTypeDefaultViewOptions]!, subtype);
  }
  else {
    return (kNoBodyViewOptions, null);
  }
}

String? formatBody(String body, MediaType? mediaType){
  if(mediaType != null){
    var subtype = mediaType.subtype;
    try {
      if(subtype.contains(kSubTypeJson)){        
        final tmp = jsonDecode(body);
        String result = kEncoder.convert(tmp);
        return result;
      }
      if(subtype.contains(kSubTypeXml)){
        final document = XmlDocument.parse(body);
        String result = document.toXmlString(pretty: true, indent: '  ');
        return result;
      }
      if(subtype == kSubTypeHtml){
        var len = body.length;
        var lines = kSplitter.convert(body);
        var numOfLines = lines.length;
        if(numOfLines !=0 && len/numOfLines <= kCodeCharsPerLineLimit){
          return body;
        }
      }
    } catch (e) {
      return null;
    }
  }
  return null;
}