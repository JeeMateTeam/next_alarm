package com.scalz.next_alarm

import android.annotation.TargetApi
import android.app.AlarmManager
import android.app.AlarmManager.ACTION_NEXT_ALARM_CLOCK_CHANGED
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.GregorianCalendar
import java.util.TimeZone

/** NextAlarmPlugin */
class NextAlarmPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var applicationContext: Context? = null
  private val TAG = "NextAlarm"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "next_alarm")


    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "next_alarm_changed")
    eventChannel!!.setStreamHandler(this)

    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getNextAlarm") {
      result.success(getNextAlarmDate());
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel?.setStreamHandler(null);
    eventChannel = null;
  }

  @TargetApi(Build.VERSION_CODES.LOLLIPOP)
  private fun getNextAlarmDate(): Map<String, Any?> {
    var alarmSource = ""
    var triggerTime = 0L
    var local = ""
    var utc = "unavailable"

    try {
      val alarmManager = applicationContext?.getSystemService(Context.ALARM_SERVICE) as AlarmManager
      val alarmClockInfo = alarmManager.nextAlarmClock

      if (alarmClockInfo  != null) {
        triggerTime = alarmClockInfo.triggerTime
        alarmSource = alarmClockInfo?.showIntent?.creatorPackage ?: "Unknown"
        Log.d(TAG, "Next alarm is scheduled by $alarmSource with trigger time $triggerTime");

        val calendar: Calendar = GregorianCalendar()
        calendar.timeInMillis = triggerTime
        val fmtLocal = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        fmtLocal.setCalendar(calendar)
        local = fmtLocal.format(calendar.time)

        val fmtUTF = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        fmtUTF.timeZone = TimeZone.getTimeZone("UTC")
        utc = fmtUTF.format(Date(triggerTime))
      }
      else {
        Log.d(TAG, "No alarm is scheduled")
      }
    } catch (e: Exception) {
      Log.e(TAG, "Error getting the next alarm info", e)
    }

    return mapOf(
            "alarmSource" to alarmSource,
            "local" to local,
            "triggerTime" to triggerTime,
            "utc" to utc
    );
  }


  private var nextAlarmReceiver: BroadcastReceiver? = null
  private var eventChannel: EventChannel? = null

  @TargetApi(Build.VERSION_CODES.LOLLIPOP)
  override fun onListen(arguments: Any?, events: EventSink) {
    nextAlarmReceiver = createNextAlarmChangeReceiver(events)
    applicationContext!!.registerReceiver(
            nextAlarmReceiver, IntentFilter(ACTION_NEXT_ALARM_CLOCK_CHANGED))
    val status: Map<String, Any?> = getNextAlarmDate()
    publishNextAlarm(events, status)
  }

  override fun onCancel(arguments: Any?) {
    applicationContext!!.unregisterReceiver(nextAlarmReceiver)
    nextAlarmReceiver = null
  }

  private fun publishNextAlarm(events: EventSink, status: Map<String, Any?>?) {
    if (status != null) {
      events.success(status)
    } else {
      events.error("UNAVAILABLE", "Next Alarm status unavailable", null)
    }
  }

  @TargetApi(Build.VERSION_CODES.LOLLIPOP)
  private fun createNextAlarmChangeReceiver(events: EventSink): BroadcastReceiver {
    return object : BroadcastReceiver() {
      override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (ACTION_NEXT_ALARM_CLOCK_CHANGED == action) {
          publishNextAlarm(events, getNextAlarmDate())
        }
      }
    }
  }

}
