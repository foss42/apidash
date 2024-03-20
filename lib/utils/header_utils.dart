Map<String, String> headers = {
  "Accept": "Specifies the media types that are acceptable for the response.",
  "Accept-Encoding":
      "Indicates the encoding methods the client can understand.",
  "Accept-Charset": "Specifies the character sets that are acceptable.",
  "Access-Control-Allow-Credentials":"Indicates whether the response to the request can be exposed when the credentials flag is true.",
  "Access-Control-Allow-Headers":
      "Specifies a list of HTTP headers that can be used in an actual request after a preflight request including the Access-Control-Request-Headers header is made.",
  "Access-Control-Allow-Methods":
      "Specifies a list of HTTP request methods allowed during CORS. ",
  "Access-Control-Expose-Headers":"Indicates which headers can be exposed as part of the response by listing their names.",
  "Access-Control-Allow-Origin":
      "Indicates whether the response can be shared with the requesting code from the given origin.",
  "Access-Control-Max-Age":
      "Indicates the maximum amount of time the results of a preflight request can be cached.",
  "Access-Control-Request-Headers":
      "Used in preflight requests during CORS to specify the headers that will be included in the actual request.",
  "Access-Control-Request-Method":
      "Used in preflight requests during CORS to indicate the HTTP method that will be used in the actual request.",
  "Accept-Ranges":"Indicates if the server supports range requests, and if so in which unit the range can be expressed.",
  "Accept-Language":
      "Specifies the preferred natural language and locale for the response.",
  "Allow":"Lists the set of HTTP request methods supported by a resource.",
  "Authorization":
      "Contains credentials for authenticating the client with the server.",
  "Authorization Bearer Token": "Often used for token-based authentication.",
  "Proxy-Authenticate":"Defines the authentication method that should be used to access a resource behind a proxy server.",
  "Cache-Control":
      "Provides directives for caching mechanisms in both requests and responses.",
  "Connection":
      "Informs whether the connection stays open or close after the current transaction finishes.",
  "Content-Disposition":
      "Specifies the presentation style (inline or attachment) of the response.",
  "Content-Encoding":
      "Indicates the encoding transformations that have been applied to the entity body of the response.",
  "Content-Language":"Describes the human language(s) intended for the audience, so that it allows a user to differentiate according to the users' own preferred language.",
  "Content-Location":"Indicates an alternate location for the returned data.",
  "Content-Length":
      "Indicates the size of the message body sent to the recipient in bytes.",
  "Content-Security-Policy":
      "Controls the sources from which content can be loaded on a web page to mitigate various types of attacks.",
  "Content-Type":
      "Indicates the original media type of the resource (prior to any content encoding applied for sending)",
  "Content-Range":"Indicates where in a full body message a partial message belongs.",
  "Cookie": "Used to send previously stored cookies back to the server.",
  "Cross-Origin-Embedder-Policy":
      "Controls whether a document is allowed to be embedded in another document.",
  "Cross-Origin-Opener-Policy":
      "Controls which documents are allowed to open a new window or access the current window.",
  "Cross-Origin-Resource-Policy":
      "Controls how cross-origin requests for resources are handled.",
  "Content-Security-Policy-Report-Only":"Allows web developers to experiment with policies by monitoring, but not enforcing, their effects. These violation reports consist of JSON documents sent via an HTTP POST request to the specified URI.",
  "Clear-Site-Data":"Clears browsing data (e.g. cookies, storage, cache) associated with the requesting website.",
  "Date": "Indicates the date and time at which the message was sent.",
  "Device-Memory":
      "Indicates the approximate amount of device memory in gigabytes.",
  "DNT":
      "Informs websites whether the user's preference is to opt out of online tracking.",
  "Expect": "Indicates certain expectations that need to be met by the server.",
  "Expires":
      "Contains the date/time after which the response is considered expired",
  "ETag":"A unique string identifying the version of the resource. Conditional requests using If-Match and If-None-Match use this value to change the behavior of the request.",
  "Forwarded":
      "Contains information from the client-facing side of proxy servers that is altered or lost when a proxy is involved in the path of the request.",
  "From": "Contains an Internet email address for a human user who controls the requesting user agent.",
  "Host": "Specifies the domain name of the server and the port number.",
  "If-Match":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "If-Modified-Since":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "If-None-Match":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "If-Range":
      "Used in conjunction with the Range header to conditionally request a partial resource.",
  "If-Unmodified-Since":
      "Used for conditional requests, allows the server to respond based on certain conditions.",
  "Keep-Alive":
      "Used to allow the connection to be reused for further requests.",
  "Last-Modified":"Indicates the date and time at which the resource was last modified.",
  "Location":
      "Indicates the URL a client should redirect to for further interaction.",
  "Max-Forwards":
      "Indicates the remaining number of times a request can be forwarded by proxies.",
  "Origin": "Specifies the origin of a cross-origin request.",
  "Permissions-Policy":"Provides a mechanism to allow and deny the use of browser features in a website's own frame, and in <iframe>s that it embeds.",
  "Proxy-Authorization":
      "Contains credentials for authenticating a client with a proxy server.",
  "Range":
      "Used to request only part of a resource, typically in the context of downloading large files.",
  "Referer":
      "Indicates the URL of the page that referred the client to the current URL.",
  "Referrer-Policy":
      "Specifies how much information the browser should include in the Referer header when navigating to other pages.",
  "Retry-After":
      "Informs the client how long it should wait before making another request after a server has responded with a rate-limiting status code.",
  "Save-Data":
      "Indicates the client's preference for reduced data usage.",
  "Server": "Indicates the software used by the origin server.",
  "Set-Cookie":
      "Send cookies from the server to the user-agent.",
  "Strict-Transport-Security":
      "Instructs the browser to always use HTTPS for the given domain.",
  "TE": "Specifies the transfer encodings that are acceptable to the client.",
  "Timing-Allow-Origin":"Specifies origins that are allowed to see values of attributes retrieved via features of the Resource Timing API, which would otherwise be reported as zero due to cross-origin restrictions.",
  "Upgrade-Insecure-Requests":
      "Instructs the browser to prefer secure connections when available.",
  "User-Agent":
      "Identifies the client software and version making the request.",
  "Vary":"Determines how to match request headers to decide whether a cached response can be used rather than requesting a fresh one from the origin server.",
  "Via":
      "Indicates intermediate proxies or gateways through which the request or response has passed.",
  "WWW-Authenticate":"Defines the authentication method that should be used to access a resource.",
  "X-Api-Key": "Used to authenticate requests to an API with an API key.",
  "X-Content-Type-Options":
      "Used to prevent browsers from MIME-sniffing a response.",
  "X-CSRF-Token":
      "Used for protection against Cross-Site Request Forgery (CSRF) attacks.",
  "X-Forwarded-For":
      "Identifies the client's original IP address when behind a proxy or load balancer.",
  "X-Frame-Options":
      "Controls whether a webpage can be displayed within an iframe or other embedded frame elements.",
  "X-Requested-With":
      "Indicates whether the request was made with JavaScript using XMLHttpRequest.",
  "X-XSS-Protection":
      "Enables or disables the browser's built-in cross-site scripting (XSS) filter.",
};

List<String> getHeaderSuggestions(String pattern) {
  return headers.keys
      .where(
        (element) => element.toLowerCase().contains(pattern.toLowerCase()),
      )
      .toList();
}
