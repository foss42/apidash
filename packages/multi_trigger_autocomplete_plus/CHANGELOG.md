## 1.0.2

- Added `AutocompleteNoTrigger` to display autocomplete suggestions without requiring any trigger character or string.

## 1.0.1

- Made `triggerEnd` customizable instead of using a hardcoded space (`' '`).
- Enhanced the handling of triggers that share a common prefix, such as `{` and `{{`, ensuring that the correct trigger is identified and processed.

## 1.0.0

- Fixed `FieldView` focus getting lost on clicking the `OptionsView` on non-mobile platforms.
- Fixed `RangeError` when `textEditingValue.selection.isInvalid`.
  [#11](https://github.com/xsahil03x/multi_trigger_autocomplete/issues/11)
- Fixed `AutocompleteTrigger` not getting triggered when the text is a multi-line
  string. [#12](https://github.com/xsahil03x/multi_trigger_autocomplete/issues/12)

## 0.1.1

- Fixed Readme.

## 0.1.0

- Initial release.
