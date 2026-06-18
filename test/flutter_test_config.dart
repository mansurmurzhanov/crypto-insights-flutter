import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> testExecutable(
  FutureOr<void> Function() testMain,
) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  const channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    return Directory.systemTemp.path;
  });

  await mockNetworkImagesFor(() async {
    await testMain();
  });
}