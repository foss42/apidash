# History Service Implementation for Auto-Clearing API Requests

## Team Dart Knight

+ User - `Vishwa Karthik`
+ Mail - `vishwa.prarthana@gmail.com`


## Overview

This document outlines the implementation of the autoClearHistory feature in APIDASH to efficiently manage stored API request history while maintaining a smooth user experience across all supported platforms.

## Features
### Auto-Clear History on App Launch

+ When the app is launched, it automatically clears 50 old API records to prevent excessive local storage usage.

+ This helps in keeping the app responsive and prevents unnecessary memory consumption.

+ Triggered using autoClearHistory() from HistoryServiceImpl.

### Dynamic Auto-Clear Trigger (State Management-Based)

+ Uses Riverpod StateNotifier to monitor the API request list dynamically.

+ If the length exceeds 50, the history is automatically trimmed, keeping only the latest 50 requests.

+ This ensures automatic cleanup without relying on platform-dependent lifecycle events.

### Platform-Specific Cleanup Handling

+ For Android & iOS: Uses AppLifecycleState.paused via WidgetsBindingObserver to trigger autoClearHistory() when the app goes to the background.

+ For Windows, macOS, Linux:Uses window_manager to detect app minimize/close events and trigger cleanup accordingly.

+ Ensures proper handling since AppLifecycleState does not work on desktops.

### Batch Deletion Strategy

+ Deleting 50 records at a time minimizes performance issues.

+ Ensures smooth UX by avoiding excessive database transactions.

+ Users can continue adding new requests seamlessly without experiencing lag.