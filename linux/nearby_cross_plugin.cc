#include "include/nearby_cross/nearby_cross_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define NEARBY_CROSS_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), nearby_cross_plugin_get_type(), \
                              NearbyCrossPlugin))

struct _NearbyCrossPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(NearbyCrossPlugin, nearby_cross_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void nearby_cross_plugin_handle_method_call(
    NearbyCrossPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data = {};
    uname(&uname_data);
    g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
    g_autoptr(FlValue) result = fl_value_new_string(version);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void nearby_cross_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(nearby_cross_plugin_parent_class)->dispose(object);
}

static void nearby_cross_plugin_class_init(NearbyCrossPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = nearby_cross_plugin_dispose;
}

static void nearby_cross_plugin_init(NearbyCrossPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  NearbyCrossPlugin* plugin = NEARBY_CROSS_PLUGIN(user_data);
  nearby_cross_plugin_handle_method_call(plugin, method_call);
}

void nearby_cross_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  NearbyCrossPlugin* plugin = NEARBY_CROSS_PLUGIN(
      g_object_new(nearby_cross_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "nearby_cross",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
