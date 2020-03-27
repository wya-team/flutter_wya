import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cache/cache_until.dart';

void main() {
  const MethodChannel channel = MethodChannel('cache');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
//    expect(await Cache.platformVersion, '42');
  });

  test('loadCache', () async {
    expect(await Cache.loadCache(), '42');
  });
}
