import 'package:flutter_test/flutter_test.dart';
import 'package:next_alarm/next_alarm.dart';
import 'package:next_alarm/next_alarm_info.dart';
import 'package:next_alarm/next_alarm_platform_interface.dart';
import 'package:next_alarm/next_alarm_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNextAlarmPlatform 
    with MockPlatformInterfaceMixin
    implements NextAlarmPlatform {

  @override
  Future<NextAlarmInfo?> getNextAlarm() => Future.value(NextAlarmInfo());

  @override
  Stream<NextAlarmInfo?> onNextAlarmChanged = Stream<NextAlarmInfo?>.periodic(const Duration(seconds: 1), (x) => NextAlarmInfo());
}

void main() {
  final NextAlarmPlatform initialPlatform = NextAlarmPlatform.instance;

  test('$MethodChannelNextAlarm is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNextAlarm>());
  });

  test('getNextAlarm', () async {
    NextAlarm nextAlarmPlugin = NextAlarm();
    MockNextAlarmPlatform fakePlatform = MockNextAlarmPlatform();
    NextAlarmPlatform.instance = fakePlatform;
  
    expect(await nextAlarmPlugin.getNextAlarm(), 0);
  });
}
