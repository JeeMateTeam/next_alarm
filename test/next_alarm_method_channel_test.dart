import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_alarm/next_alarm_method_channel.dart';

void main() {
  MethodChannelNextAlarm platform = MethodChannelNextAlarm();
  const MethodChannel channel = MethodChannel('next_alarm');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 0;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getNextAlarm', () async {
    expect(await platform.getNextAlarm(), 0);
  });
}
