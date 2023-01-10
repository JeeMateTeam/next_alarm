import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'next_alarm_platform_interface.dart';
import 'next_alarm_info.dart';

/// An implementation of [NextAlarmPlatform] that uses method channels.
class MethodChannelNextAlarm extends NextAlarmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('next_alarm');

  NextAlarmInfo? parseNextAlarmEvent(dynamic event) {
    try {
      return NextAlarmInfo.fromMap(Map<String, dynamic>.from(event));
    } catch (e) {
      debugPrint("NextAlarm:parseNextAlarmEvent failed : '${e.toString()}'.");
    }
    return null;
  }

  @override
  Future<NextAlarmInfo?> getNextAlarm() async {
    try {
      var res = await methodChannel.invokeMethod('getNextAlarm');
      if (res!=null) {
        final result =  parseNextAlarmEvent(res);
        if (result!=null) {
          return result;
        }
        debugPrint('NextAlarm:getNextAlarm: No alarm is scheduled');
      }
    } on PlatformException catch (e) {
      debugPrint("NextAlarm:getNextAlarm failed : '${e.message}'.");
    }
    return null;
  }

  /// The event channel used to receive DateTime changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel = const EventChannel('next_alarm_changed');

  Stream<NextAlarmInfo?>? _onNextAlarmChanged;
  @override
  Stream<NextAlarmInfo?> get onNextAlarmChanged {
    _onNextAlarmChanged ??= eventChannel.receiveBroadcastStream().map((dynamic event) => parseNextAlarmEvent(event));
    return _onNextAlarmChanged!;
  }
}
