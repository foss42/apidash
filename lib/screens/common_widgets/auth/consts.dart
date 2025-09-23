const kEmpty = '';

enum OAuth2Field {
  authorizationUrl,
  accessTokenUrl,
  clientId,
  clientSecret,
  redirectUrl,
  scope,
  state,
  codeChallengeMethod,
  username,
  password,
  refreshToken,
  identityToken,
  accessToken,
  clearSession,
}

// API Key Auth
const kApiKeyHeaderName = 'x-api-key';
const kAddToLocations = [
  ('header', 'Header'),
  ('query', 'Query Params'),
];
final kAddToDefaultLocation = kAddToLocations[0].$1;
final kAddToLocationsMap = {for (var v in kAddToLocations) v.$1: v.$2};
const kLabelAddTo = "Add to";
const kTooltipApiKeyAuth = "Select where to add API key";
const kHintTextFieldName = "Header/Query Param Name";
const kLabelApiKey = "API Key";
const kHintTextKey = "Key";

// Username-password auth
const kHintUsername = "Username";
const kHintPassword = "Password";

// Bearer Token AUth
const kHintToken = "Token";

// Digest Auth
const kInfoDigestUsername =
    "Your username for digest authentication. This will be sent to the server for credential verification.";
const kInfoDigestPassword =
    "Your password for digest authentication. This is hashed and not sent in plain text to the server.";
const kHintRealm = "Realm";
const kInfoDigestRealm =
    "Authentication realm as specified by the server. This defines the protection space for the credentials.";
const kHintNonce = "Nonce";
const kInfoDigestNonce =
    "Server-generated random value used to prevent replay attacks.";
const kAlgorithm = "Algorithm";
const kTooltipAlgorithm = "Algorithm that will be used to produce the digest";
const kHintQop = "QOP";
const kInfoDigestQop =
    "Quality of Protection. Typically 'auth' for authentication only, or 'auth-int' for authentication with integrity protection.";
const kHintDataString = "Opaque";
const kInfoDigestDataString =
    "Server-specified data string that should be returned unchanged in the authorization header. Usually obtained from server's 401 response.";

// JWT Auth
const kMsgAddToken = "Add JWT token to";
const kTooltipTokenAddTo = "Select where to add JWT token";
const kTextAlgo = "Algorithm";
const kTooltipJWTAlgo = "Select JWT algorithm";
const kStartAlgo = "HS";
const kHintSecret = "Secret Key";
const kInfoSecret =
    "The secret key used to sign the JWT token. Keep this secure and match it with your server configuration.";
const kMsgSecret = "Secret is Base64 encoded";
const kMsgPrivateKey = "Private Key";
const kHintRSA = '''
-----BEGIN RSA PRIVATE KEY-----
Private Key in PKCS#8 PEM Format
-----END RSA PRIVATE KEY-----
''';
const kMsgPayload = "Payload (JSON format)";
const kHintJson =
    '{"sub": "1234567890", "name": "John Doe", "iat": 1516239022}';
const kHeaderPrefix = 'Bearer';
const kQueryParamKey = 'token';

// OAuth1 Auth
const kHintOAuth1ConsumerKey = "Consumer Key";
const kInfoOAuth1ConsumerKey =
    "The consumer key provided by the service provider to identify your application.";
const kHintOAuth1ConsumerSecret = "Consumer Secret";
const kInfoOAuth1ConsumerSecret =
    "The consumer secret provided by the service provider. Keep this secure and never expose it publicly.";
const kHintOAuth1AccessToken = "Access Token";
const kInfoOAuth1AccessToken =
    "The access token obtained after user authorization. This represents the user's permission to access their data.";
const kHintOAuth1TokenSecret = "Token Secret";
const kInfoOAuth1TokenSecret =
    "The token secret associated with the access token. Used to sign requests along with the consumer secret.";
const kHintOAuth1CallbackUrl = "Callback URL";
const kInfoOAuth1CallbackUrl =
    "The URL where the user will be redirected after authorization. Must match the URL registered with the service provider.";
const kHintOAuth1Verifier = "Verifier";
const kInfoOAuth1Verifier =
    "The verification code received after user authorization. Used to exchange the request token for an access token.";
const kHintOAuth1Timestamp = "Timestamp";
const kInfoOAuth1Timestamp =
    "Unix timestamp when the request is made. Usually generated automatically to prevent replay attacks.";
const kHintOAuth1Nonce = "Nonce";
const kInfoOAuth1Nonce =
    "A unique random string for each request. Helps prevent replay attacks and ensures request uniqueness.";
const kHintOAuth1Realm = "Realm";
const kInfoOAuth1Realm =
    "Optional realm parameter that defines the protection space. Some services require this for proper authentication.";
const kLabelOAuth1SignatureMethod = "Signature Method";
const kTooltipOAuth1SignatureMethod =
    "Select the signature method for OAuth 1.0 authentication";

// OAuth2 Auth
const kLabelOAuth2GrantType = "Grant Type";
const kTooltipOAuth2GrantType = "Select OAuth 2.0 grant type";
const kHintOAuth2AuthorizationUrl = "Authorization URL";
const kInfoOAuth2AuthorizationUrl =
    "The authorization endpoint URL where users are redirected to grant permission to your application.";
const kHintOAuth2AccessTokenUrl = "Access Token URL";
const kInfoOAuth2AccessTokenUrl =
    "The token endpoint URL where authorization codes are exchanged for access tokens.";
const kHintOAuth2ClientId = "Client ID";
const kInfoOAuth2ClientId =
    "The client identifier issued to your application by the authorization server.";
const kHintOAuth2ClientSecret = "Client Secret";
const kInfoOAuth2ClientSecret =
    "The client secret issued to your application. Keep this secure and never expose it publicly.";
const kHintOAuth2RedirectUrl = "Redirect URL";
const kInfoOAuth2RedirectUrl =
    "The URL where users are redirected after authorization. Must match the URL registered with the service.";
const kHintOAuth2Scope = "Scope";
const kInfoOAuth2Scope =
    "Space-separated list of permissions your application is requesting access to.";
const kHintOAuth2State = "State";
const kInfoOAuth2State =
    "An unguessable random string used to protect against cross-site request forgery attacks.";
const kHintOAuth2Username = "Username";
const kInfoOAuth2Username =
    "Your username for resource owner password credentials grant type.";
const kHintOAuth2Password = "Password";
const kInfoOAuth2Password =
    "Your password for resource owner password credentials grant type.";
const kHintOAuth2RefreshToken = "Refresh Token";
const kInfoOAuth2RefreshToken =
    "Token used to obtain new access tokens when the current access token expires.";
const kHintOAuth2IdentityToken = "Identity Token";
const kInfoOAuth2IdentityToken =
    "JWT token containing user identity information, typically used in OpenID Connect flows.";
const kHintOAuth2AccessToken = "Access Token";
const kInfoOAuth2AccessToken =
    "The token used to access protected resources on behalf of the user.";
const kLabelOAuth2CodeChallengeMethod = "Code Challenge Method";
const kTooltipOAuth2CodeChallengeMethod =
    "Code challenge method for PKCE (Proof Key for Code Exchange)";
const kButtonClearOAuth2Session = "Clear OAuth2 Session";

//AuthPAge
const kLabelSelectAuthType = "Authentication Type";
const kTooltipSelectAuth = "Select Authentication Type";
const kMsgNoAuth = "No authentication was used for this request.";
const kMsgNoAuthSelected = "No authentication selected.";
const kMsgAuthNotSupported =
    "authentication details are not yet supported in history view.";
const kMsgNotImplemented = "This auth type is not implemented yet.";
