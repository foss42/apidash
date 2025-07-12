const kEmpty = '';
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

const kHintUsername = "Username";
const kHintPassword = "Password";

const kHintToken = "Token";

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
