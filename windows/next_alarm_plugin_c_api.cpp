#include "include/next_alarm/next_alarm_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "next_alarm_plugin.h"

void NextAlarmPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  next_alarm::NextAlarmPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
