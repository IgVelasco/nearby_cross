#include "include/nearby_cross/nearby_cross_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "nearby_cross_plugin.h"

void NearbyCrossPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  nearby_cross::NearbyCrossPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
