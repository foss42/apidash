# Workspace persistence

Requests and environments have separate Riverpod notifiers and Hive boxes.
`CollectionStateNotifier.saveWorkspace()` coordinates the two existing save
methods, `saveData()` and `EnvironmentsStateNotifier.saveEnvironments()`. The
sidebar Save button and desktop close-dialog Save action both await this operation.
The window closes only after both saves succeed. A failed save propagates the
error, clears the saving indicator, and leaves unsaved changes flagged for retry.
The two box writes are sequential, not a transaction across boxes.

`HiveHandler.removeUnused()` removes request and environment records absent from
their respective saved ID lists. In the request box it preserves both reserved
keys: `kKeyDataBoxIds` (request order) and `kKeyWsTemplatesBox` (WebSocket message
templates). Template persistence must not depend on whether any requests exist.

Offline regression coverage for this flow lives in
`test/providers/workspace_persistence_test.dart` and uses isolated temporary Hive
storage and notifier overrides. It checks persisted records after reopening the
boxes, reserved-key preservation, save completion ordering, and failure recovery.
