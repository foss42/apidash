#!/bin/bash
echo "🔄 Running pre-publish steps..."
dart run tool/json_to_dart.dart
echo "✅ Pre-publish steps completed."
