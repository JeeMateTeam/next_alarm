import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:next_alarm/next_alarm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? _nextAlarm;
  final _nextAlarmPlugin = NextAlarm();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    DateTime? nextAlarm;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      nextAlarm = await _nextAlarmPlugin.getNextAlarm();
      if (nextAlarm == null) print('No alarm or failed to get it');
    } on PlatformException {
      print('Failed to get next alarm.');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
        body: Center(
          child: Text('Next alarm: ${_nextAlarm ?? 'unknown'}\n'),
        ),
      ),
    );
  }
}
