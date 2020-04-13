import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_gallery/native_gallery.dart';

void main() {
  const MethodChannel channel = MethodChannel('native_gallery');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}
