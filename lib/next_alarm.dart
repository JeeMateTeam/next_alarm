import 'dart:io';

import 'next_alarm_platform_interface.dart';
import 'next_alarm_info.dart';

class NextAlarm {
  /// Get next scheduled alarm
  Future<NextAlarmInfo?> getNextAlarm() async {
    if (Platform.isAndroid) {
      return await NextAlarmPlatform.instance.getNextAlarm();
    } else {
      return null;
    }
  }
  /// Fires whenever the next scheduled alarm changes.
  Stream<NextAlarmInfo?> get onNextAlarmChanged {
    return NextAlarmPlatform.instance.onNextAlarmChanged;
  }
}

