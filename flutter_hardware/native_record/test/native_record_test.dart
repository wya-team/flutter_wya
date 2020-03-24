import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_record/native_record.dart';

void main() {
  const MethodChannel channel = MethodChannel('native_record');

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
    expect(await NativeRecord.platformVersion, '42');
  });
}
