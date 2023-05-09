#ifndef FLUTTER_PLUGIN_NEARBY_CROSS_PLUGIN_H_
#define FLUTTER_PLUGIN_NEARBY_CROSS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace nearby_cross {

class NearbyCrossPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NearbyCrossPlugin();

  virtual ~NearbyCrossPlugin();

  // Disallow copy and assign.
  NearbyCrossPlugin(const NearbyCrossPlugin&) = delete;
  NearbyCrossPlugin& operator=(const NearbyCrossPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace nearby_cross

#endif  // FLUTTER_PLUGIN_NEARBY_CROSS_PLUGIN_H_
