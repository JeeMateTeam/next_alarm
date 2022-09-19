import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'next_alarm_method_channel.dart';

abstract class NextAlarmPlatform extends PlatformInterface {
  /// Constructs a NextAlarmPlatform.
  NextAlarmPlatform() : super(token: _token);

  static final Object _token = Object();

  static NextAlarmPlatform _instance = MethodChannelNextAlarm();

  /// The default instance of [NextAlarmPlatform] to use.
  ///
  /// Defaults to [MethodChannelNextAlarm].
  static NextAlarmPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NextAlarmPlatform] when
  /// they register themselves.
  static set instance(NextAlarmPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<DateTime?> getNextAlarm() async {
    return await _instance.getNextAlarm();
  }

  /// Returns a Stream of DateTime? changes.
  Stream<DateTime?> get onNextAlarmChanged {
    return _instance.onNextAlarmChanged;
  }
}
