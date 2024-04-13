import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/constants/app.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross_example/models/example_info_manager.dart';
import 'package:nearby_cross_example/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
  const appMode =
      String.fromEnvironment("APP_MODE", defaultValue: 'experimental');
  Logger().i("Starting app in $appMode mode");

  if (AppMode.values.byName(appMode) == AppMode.experimental) {
    // In experimental mode we let the devices create/retrieve their own Public/Private Keys
    var connectionsManager = ConnectionsManager();
    connectionsManager.setIdentifier('test_experimental');
  } else {
    // If we are not in experimental mode, we will force devices to use a Public/Private Keys
    // declared in ExampleInfoManager
    const profile = String.fromEnvironment("PROFILE", defaultValue: 'DOCENTE');

    Logger().i("Setting profile: $profile");
    var exampleInfoManager = ExampleInfoManager();
    var profileData = exampleInfoManager.getDataForProfile(profile);
    var connectionsManager = ConnectionsManager(
        appMode: AppMode.values.byName(appMode),
        peerIdentifications: exampleInfoManager,
        keyPairJwk: profileData);
    connectionsManager.setIdentifier(exampleInfoManager.devices[profile]!);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainScreen());
  }
}
