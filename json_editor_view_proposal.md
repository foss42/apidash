# Proposal: Implementing a JSON Editor View for ApiDash

I encountered this missing functionality when compared with other softwares in the market where JSON Editor 

P.S - Sometimes I'm thinking out loud while drafting this.

## Features 
+ Syntax Highlighting
+ JSON Validator
+ JSON Beautification
+ Object Indentation
+ Automatic Bracket Completer
+ Implement Line Number
+ Show Error Line
+ Allow comments? (should we include this?)

## Edge Cases Considered

+ Extremely Large JSON Objects: To tackle entire process when large objectts is pasted into the editor.

+ Incorrectly Formatted JSON: Simple Error IconData over the line number to show where error could be? (like missing comma, trailing comma error)

+ Editing JSON with Comments: If supporting JSON5, do we need to allow comments, or skip them entirely.

+ Partial JSON Input: Gotta ensure the editor don't break when incomplete JSON is entered.


## Recommendation

+ We can build custom JsonEditorView using "json_text_editor" package or can we reuse APIDASH's "json_explorer" package to reduce development time?

## Questions for Maintainer
+ How do you want to prioritize this enhancement? Is this good to have feature?
+ If we support JSON, do we have any future plan to incorporate XML?
