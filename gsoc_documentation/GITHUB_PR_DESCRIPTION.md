# Pull Request: WebSocket Support for API Dash (#15)

## 🎯 Purpose
This PR implements comprehensive WebSocket support as part of the **GSoC 2026** initiative. It addresses **Issue #15** by providing a robust, cross-platform real-time protocol testing interface within API Dash.

## ✨ Key Features
- **Cross-Platform Networking**: 
  - Implemented `WebSocketService` using `web_socket_channel`.
  - Platform-specific handlers for Native (IO) and Web (HTML) via conditional exports.
- **WebSocket Code Generation**:
  - **Python**: Client implementation using the `websocket-client` library.
  - **JavaScript**: Browser-native implementation.
- **Intelligent URL Handling**:
  - Automatic normalization and scheme mapping (e.g., `https://` -> `wss://`, `http://` -> `ws://`).
- **Enhanced UI/UX**:
  - Color-coded message logs (Connect, Sent, Received, Error, Disconnect).
  - Real-time auto-reverse scrolling for continuous streams.
- **Production Hardening**:
  - Added macOS Sandbox entitlements for file pickers and network client access.
  - Updated `google_fonts` to resolve `AssetManifest.json` loading issues in newer Flutter versions.

## 🛠 Technical Details
- Added `WebSocketRequestModel` and `WebSocketConnectionModel` to handle complex states.
- Integrated WebSocket state into `CollectionStateNotifier` with Riverpod.
- Cleaned up multiple lints and updated dependencies to ensure compatibility with Flutter 3.29.0.

## 📝 GSOC Documentation
I have included detailed project documentation in the `gsoc_documentation/` directory:
- `implementation_audit.md`: A technical breakdown of how the implementation meets the proposal goals.
- `next_steps_roadmap.md`: A plan for future enhancements like binary support and ping/pong heartbeats.

## ✅ Verification
- Tested on macOS (Darwin-arm64).
- Verified against multiple public echo servers.
- Code generation verified in local IDE.

---
*Submitted as part of the GSoC 2026 application for Issue #15.*
