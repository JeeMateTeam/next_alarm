import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:next_alarm/next_alarm.dart';
import 'package:next_alarm/next_alarm_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NextAlarmInfo? _nextAlarm;
  final _nextAlarmPlugin = NextAlarm();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    NextAlarmInfo? nextAlarm;

    try {
      nextAlarm = await _nextAlarmPlugin.getNextAlarm();
    } on PlatformException {
      debugPrint('Failed to get next alarm.');
    }

    if (!mounted) return;

    setState(() {
      _nextAlarm = nextAlarm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NextAlarm example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_nextAlarm==null)
              const Text('No scheduled alarm')
            else
              Text('Next alarm is scheduled by ${_nextAlarm!.alarmSource}\n'
                  'triggerTime: ${_nextAlarm!.triggerTime}\n'
                  'localTime: ${_nextAlarm!.localTime}\n'
                  'utcTime: ${_nextAlarm!.utcTime}'),
          ],
        ),
      ),
    );
  }
}
