#!/bin/bash

set -e

flutter analyze
flutter test
flutter test integration_test/app_flow_test.dart -d macos
flutter test --coverage