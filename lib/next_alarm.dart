import 'dart:io';

import 'next_alarm_platform_interface.dart';

class NextAlarm {
  /// Get next scheduled alarm
  Future<DateTime?> getNextAlarm() async {
    if (Platform.isAndroid) {
      return await NextAlarmPlatform.instance.getNextAlarm();
    } else {
      return null;
    }
  }
}
