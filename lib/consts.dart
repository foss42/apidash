enum HTTPVerb { get, head, post, put, patch, delete }

enum ContentType { json, text }

const DEFAULT_METHOD = HTTPVerb.get;
const DEFAULT_BODY_CONTENT_TYPE = ContentType.json;
