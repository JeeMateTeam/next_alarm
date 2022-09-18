package com.scalz.next_alarm

import android.annotation.TargetApi
import android.app.AlarmManager
import android.content.Context
import android.os.Build
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NextAlarmPlugin */
class NextAlarmPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var applicationContext: Context? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "next_alarm")
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
  }

  @TargetApi(Build.VERSION_CODES.LOLLIPOP)
  private fun getNextAlarmDate(): String {
    var nextAlarm = ""
    try {
      val alarmManager = applicationContext?.getSystemService(Context.ALARM_SERVICE) as AlarmManager
      if (alarmManager == null) {
        return "";
      }

      val aci: AlarmManager.AlarmClockInfo? = alarmManager.nextAlarmClock
      nextAlarm = aci?.triggerTime?.toString() ?: ""
    } catch (e: Exception) {
      e.printStackTrace()
    }
    return nextAlarm;
  }
}
