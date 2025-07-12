const kApiKeyHeaderName = 'x-api-key';
const kAddToLocations = [
  ('header', 'Header'),
  ('query', 'Query Params'),
];
final kAddToDefaultLocation = kAddToLocations[0].$1;
final kAddToLocationsMap = {for (var v in kAddToLocations) v.$1: v.$2};
const kLabelAddTo = "Add to";
const kTooltipApiKeyAuth = "Select where to add API key";
