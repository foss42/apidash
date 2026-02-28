# History Service Implementation for Auto-Clearing API Requests

Initial proposals:
- https://github.com/foss42/apidash/pull/577
- https://github.com/foss42/apidash/pull/578

Issue - https://github.com/foss42/apidash/issues/551  
PR - https://github.com/foss42/apidash/pull/604 https://github.com/foss42/apidash/pull/616  
Project Link - https://fossunited.org/hack/fosshack25/p/i0aod39ham

## Team Dart Knight

+ User - `Vishwa Karthik`
+ Mail - `vishwa.prarthana@gmail.com`

## Do Checkout
+ [Issues with Isolate & Compute Methodology](https://github.com/foss42/apidash/pull/604#issuecomment-2676863276)


## Overview

This document outlines the implementation of the autoClearHistory feature in APIDASH to efficiently manage stored API request history while maintaining a smooth user experience across all supported platforms.

## Features
### Auto-Clear History on App Launch

+ When the app is launched, it automatically clears 50 old API records to prevent excessive local storage usage.

+ This helps in keeping the app responsive and prevents unnecessary memory consumption.

+ Triggered using autoClearHistory() from HistoryServiceImpl.

### Dynamic Auto-Clear Trigger (State Management-Based)

+ Uses Riverpod StateNotifier to monitor the API request list dynamically.

+ If the length exceeds 50, the history clearance is automatically triggered, just to avoid heavy duty on app launch.

+ Reason to use State management here is to resist unnecessary local database call because user may keep switching apps/window during development cycle.

### Platform-Specific Cleanup Handling

+ For Android & iOS: Uses AppLifecycleState.paused via WidgetsBindingObserver to trigger autoClearHistory() when the app goes to the background.

+ For Windows, macOS, Linux:Uses window_manager to detect app minimize events and trigger cleanup accordingly.

+ Ensures proper handling since AppLifecycleState does not work on desktops.

### Batch Deletion Strategy

+ Deleting 50 records at a time minimizes performance issues.

+ Ensures smooth UX by avoiding excessive database transactions.

+ Users can continue adding new requests seamlessly without experiencing lag.

## [Issues with Clearing via Isolates](https://github.com/foss42/apidash/pull/604)

## My Findings...

Local Database Hive do not support concurrent connections or transactions due to Native OS locking the hive files on the user desired directory, (hive.lock) files.

+ Linux Based Arch Distributions and Apple System follow strict file lock system and wouldn't allow opening or accessing boxes from multiple isolates.

## Reasoning
+ `Hive.init` and `hive.initFlutter` are both method-channel and main UI thread operations which needs many data accessibility which are only available in main thread isolate.

## Cheap Work Around Solution
1. Close Hive in the main thread
2. Start an isolate
3. Initialize Hive in that isolate
4. Offload tasks to new isolate & Close Hive
5. Re-Open Hive Box in the main thread

## Problems
+ Although the database transactions are fast, there are high chances the database behavior becomes highly unpredictable. 
+ The cleaning service job trigger logic had to changed, since calling it main function may become stupidity.

## Technical Issues
+ With issues stated, frequent switches between threads will make too many open/close hive boxes to hinder performance of the app.
+ App may stop working abruptly
+ IOS Production app may not allow these operations to do so, and may kill the app.
+  The Hive documentation clearly states that it is not designed for multi-threaded use.
+ Simultaneous reads/writes across isolates may lead to inconsistencies.

## What about... [PR 604](https://github.com/foss42/apidash/pull/604)
+ The reason why it could have worked for Android, is due to its lenient OS behavior although its Linux-based distribution. 
+ Even though Android doesn't throw an error, it's still not safe to open Hive in multiple isolates.

## Note 
+ There is another database called 'Isar' which probably supports multi-threaded concurrent transactions which could have been possible to resolve this functionality.

## Conclusion
+ The issue opened is very real but the way it has to be tackled is just to clear them in main isolate using optimization techniques like batch request, clearing history in frequent intervals and few more everything in Main Thread ONLY.
