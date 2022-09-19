import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'next_alarm_platform_interface.dart';

/// An implementation of [NextAlarmPlatform] that uses method channels.
class MethodChannelNextAlarm extends NextAlarmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('next_alarm');

  DateTime? parseNextAlarmEvent(dynamic event) {
    var nextDate = int.tryParse('$event');
    if (nextDate!=null && nextDate>=0) {
      return DateTime.fromMillisecondsSinceEpoch(nextDate);
    }
    return null;
  }

  @override
  Future<DateTime?> getNextAlarm() async {
    try {
      var res = await methodChannel.invokeMethod('getNextAlarm');
      var nextDate = parseNextAlarmEvent(res);
      if (nextDate==null) {
        print('getNextAlarm: no next alarm');
      }
      return nextDate;
    } on PlatformException catch (e) {
      print("getNextAlarm failed : '${e.message}'.");
      return null;
    }
  }

  /// The event channel used to receive DateTime changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel = const EventChannel('next_alarm_changed');

  Stream<DateTime?>? _onNextAlarmChanged;
  @override
  Stream<DateTime?> get onNextAlarmChanged {
    _onNextAlarmChanged ??= eventChannel.receiveBroadcastStream().map((dynamic event) => parseNextAlarmEvent(event));
    return _onNextAlarmChanged!;
  }
}
