#ifndef FLUTTER_PLUGIN_NEXT_ALARM_PLUGIN_H_
#define FLUTTER_PLUGIN_NEXT_ALARM_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace next_alarm {

class NextAlarmPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NextAlarmPlugin();

  virtual ~NextAlarmPlugin();

  // Disallow copy and assign.
  NextAlarmPlugin(const NextAlarmPlugin&) = delete;
  NextAlarmPlugin& operator=(const NextAlarmPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace next_alarm

#endif  // FLUTTER_PLUGIN_NEXT_ALARM_PLUGIN_H_
