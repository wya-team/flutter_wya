import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_permissions/native_permissions.dart';

void main() {
  const MethodChannel channel = MethodChannel('native_permissions');

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
    expect(await NativePermissions.platformVersion, '42');
  });
}
