
Map<String, String> headers = {
  "Age": "It is a response header. It defines the times in seconds of the object that have been in the proxy cache.",
  "Accept": "Specifies the media types that are acceptable for the response.",
  "Accept-charset":
      "It is a request type header. This header is used to indicate what character set are acceptable for the response from the server.",
  "Accept-Encoding":
      "Indicates the encoding methods the client can understand.",
  "Access-Control-Allow-Headers":
      "Specifies a list of HTTP headers that can be used in an actual request after a preflight request including the Access-Control-Request-Headers header is made.",
  "Access-Control-Allow-Methods":
      "Specifies a list of HTTP request methods allowed during CORS. ",
  "Access-Control-Allow-Origin":
      "Indicates whether the response can be shared with the requesting code from the given origin.",
  "Access-Control-Max-Age":
      "Indicates the maximum amount of time the results of a preflight request can be cached.",
  "Access-Control-Request-Headers":
      "Used in preflight requests during CORS to specify the headers that will be included in the actual request.",
  "Access-Control-Request-Method":
      "Used in preflight requests during CORS to indicate the HTTP method that will be used in the actual request.",
  "Accept-Language":
      "Specifies the preferred natural language and locale for the response.",
  "Accept-CH":
      "It is a response-type header. It specify which Client Hints headers client should include in subsequent requests.",
  "Accept-CH-Lifetime":
      "It is a response-type header used to specify persistence of Accept-CH header value.",
  "Authorization":
      "Contains credentials for authenticating the client with the server.",
  "Authorization Bearer Token": "Often used for token-based authentication.",
  "Alt-Svc":
      "It is use to reach the website in an alternate way.",
  "Cache-Control":
      "Provides directives for caching mechanisms in both requests and responses.",
  "Clear-Site-Data":
      "It is a response-type header. This header is used in deleting the browsing data which is in the requesting website.",
  "Connection":
      "Informs whether the connection stays open or close after the current transaction finishes.",
  "Content-Disposition":
      "Specifies the presentation style (inline or attachment) of the response.",
  "Content-Encoding":
      "Indicates the encoding transformations that have been applied to the entity body of the response.",
  "Content-Length":
      "Indicates the size of the message body sent to the recipient in bytes.",
  "Content-Security-Policy":
        "Controls the sources from which content can be loaded on a web page to mitigate various types of attacks.",
  "Content-Type":
      "Indicates the original media type of the resource (prior to any content encoding applied for sending)",
  "Cookie": "Used to send previously stored cookies back to the server.",
  "Cross-Origin-Embedder-Policy":
      "Controls whether a document is allowed to be embedded in another document.",
  "Cross-Origin-Opener-Policy":
      "Controls which documents are allowed to open a new window or access the current window.",
  "Cross-Origin-Resource-Policy":
      "Controls how cross-origin requests for resources are handled.",
  "Content-DPR":
      "It is a response-type header. It is used to define the ratio between physical pixels over CSS pixels of the selected image response.",
  "DPR": "It is response-type header, It is used to defines the ratio of the physical pixels over the CSS pixels of the current window of the device.",
  "Device-Memory":
      "It is used to specify the approximate ram left on the client device.",
  "Date": "Indicates the date and time at which the message was sent.",
  "DNT":
      "Informs websites whether the user's preference is to opt out of online tracking.",
  "Early-Data":
      "It is a request-type header. This header is used indicate that the request has been conveyed in early data.",
  "ETag":
      "It is a response-type header used as an identifier for a specific version of a resource.",
  "Expect": "Indicates certain expectations that need to be met by the server.",
  "Expires":
      "Contains the date/time after which the response is considered expired",
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
      "It is a general-type header used to inform that how long a persistent connection should stay open.",
  "Last-Modified":
      "The last modified response header is a header sent by the server specifying the date of the last modification of the requested source. This is the formal definition of Last-Modified of HTTP headers.",
  "Location":
      "Indicates the URL a client should redirect to for further interaction.",
  "Large-Allocation":
      "It is a response-type header that informs supported browsers (currently only Firefox) about the needs of a memory that allows them to make sure that the large-allocation succeeds and also start a new process using some unfragmented memory.",
  "Link":
      "It is entity-type header used to serializing one or more links in HTTP headers.",
  "Origin": "Specifies the origin of a cross-origin request.",
  "Proxy-Authenticate": "It is a response header gives access to a resource file by defining an authorization method. It allows the proxy server to transmit the request further by authenticating it.",
  "Proxy-Authorization":
      "It is a request type of header. This header contains the credentials to authenticate between the user agent and the user-specified server.",
  "Pragma":
      "It is general-type header, but response behavior is not specified and thus implementation-specific.",
  "Range":
      "Used to request only part of a resource, typically in the context of downloading large files.",
  "Referer":
      "Indicates the URL of the page that referred the client to the current URL.",
  "Referrer-Policy":
      "Specifies how much information the browser should include in the Referer header when navigating to other pages.",
  "Retry-After":
      "Informs the client how long it should wait before making another request after a server has responded with a rate-limiting status code.",
  "Save-Data":
      "It is used to reduce the usage of the data on the client side.",
  "Server": "Indicates the software used by the origin server.",
  "Server-Timing":
      "It is a response-type header. This header is used to communicate between two or more metrics and descriptions for a given request-response cycle from the user agent.",
  "SourceMap":
      "It is a response-type header used to map original source from the transformed source. For example, the JavaScript resources are transformed to some other source from its original by the browsers at the time of execution.",
  "Strict-Transport-Security":
      "Instructs the browser to always use HTTPS for the given domain.",
  "Timing-Allow-Origin":
      "It is a response type header. It specify origins that are allowed to see values of attributes retrieved via features of the Resource Timing API.",
  "TK":
      "It is a response type header, it indicates the tracking status.",
  "TE": "Specifies the transfer encodings that are acceptable to the client.",
  "User-Agent":
      "Identifies the client software and version making the request.",
  "Vary":
      "It is response-type header. It is used by the server to indicate which headers it used when selecting a representation of a resource in a content negotiation algorithm.",
  "Via":
      "Indicates intermediate proxies or gateways through which the request or response has passed.",
  "Viewport-Width":
      "It is used to indicates the layout viewport width in CSS pixels.",
  "Width":
      "It is a request-type header. This header is used indicates the desired resource width in physical pixels.",
  "Warnings":
      "It is a general type header that is used to inform possible problems to the client.",
  "WWW-Authenticate":
      "It is a response header that defines the authentication method. It should be used to gain access to a resource.",
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
  "X-DNS-Prefetch-Control":
      "It is response-type header that is used to control the DNS prefetch."
};

List<String> getHeaderSuggestions(String pattern) {
  return headers.keys
      .where(
        (element) => element.toLowerCase().contains(pattern.toLowerCase()),
      )
      .toList();
}
