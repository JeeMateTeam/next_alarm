/// Next Alarm Info
class NextAlarmInfo {
  /// Package which scheduled this alarm
  String alarmSource;
  /// Alarm local time
  String local;
  /// Alarm time in milliseconds
  int triggerTime;
  /// Alarm UTC time
  String utc;

  NextAlarmInfo({
    this.alarmSource="",
    this.local="",
    this.triggerTime=0,
    this.utc="unavailable",
  });

  /// Alarm local datetime
  DateTime? get localTime => DateTime.tryParse(local);
  /// Alarm UTC datetime
  DateTime? get utcTime => DateTime.tryParse(utc);

  /// NextAlarmInfo to Map
  Map<String, dynamic> toMap() {
    return {
      'alarmSource': alarmSource,
      'local': local,
      'triggerTime': triggerTime,
      'utc': utc,
    };
  }

  /// NextAlarmInfo from Map
  factory NextAlarmInfo.fromMap(Map<String, dynamic> map) {
    return NextAlarmInfo(
      alarmSource: '${map['alarmSource'] ?? ''}',
      local: '${map['local'] ?? ''}',
      triggerTime: int.tryParse('${map['triggerTime']}') ?? 0,
      utc: '${map['utc'] ?? ''}',
    );
  }
}