import 'package:flutter/material.dart';
import 'package:nearby_cross_example/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'models/app_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        var appModel = AppModel();
        appModel.initPlatformState();
        return appModel;
      },
      child: const MyApp(),
    ),
  );
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
