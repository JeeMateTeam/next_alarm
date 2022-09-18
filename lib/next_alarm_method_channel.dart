import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'next_alarm_platform_interface.dart';

/// An implementation of [NextAlarmPlatform] that uses method channels.
class MethodChannelNextAlarm extends NextAlarmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('next_alarm');

  @override
  Future<DateTime?> getNextAlarm() async {
    try {
      var res = await methodChannel.invokeMethod('getNextAlarm');
      var nextDate = int.tryParse('$res');
      if (nextDate!=null) {
        return DateTime.fromMillisecondsSinceEpoch(nextDate);
      }
      else {
        print('getNextAlarm: no next alarm');
        return null;
      }
    } on PlatformException catch (e) {
      print("getNextAlarm failed : '${e.message}'.");
      return null;
    }
  }
}
