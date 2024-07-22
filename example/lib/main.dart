import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/constants/app.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/modules/authentication/experimental/experimental_auth_manager.dart';
import 'package:nearby_cross_example/models/example_authentication_manager.dart';
import 'package:nearby_cross_example/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
  const appMode =
      String.fromEnvironment("APP_MODE", defaultValue: 'experimental');
  Logger().i("Starting app in $appMode mode");

  if (AppMode.values.byName(appMode) == AppMode.experimental) {
    // In experimental mode we let the devices create/retrieve their own Public/Private Keys
    var experimentalAuthManager = ExperimentalAuthManager();
    experimentalAuthManager.setIdentifier('test_experimental');
    ConnectionsManager(authenticationManager: experimentalAuthManager);
  } else {
    // If we are not in experimental mode, we will force devices to use a Public/Private Keys
    // declared in ExampleAuthenticationManager
    const profile = String.fromEnvironment("PROFILE", defaultValue: 'DOCENTE');
    Logger().i("Setting profile: $profile");

    var exampleAuthManager = ExampleAuthenticationManager();
    exampleAuthManager.setIdentifier(exampleAuthManager.devices[profile]!);
    ConnectionsManager(authenticationManager: exampleAuthManager);
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
