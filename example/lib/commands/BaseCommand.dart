import 'package:flutter/widgets.dart';
import 'package:nearby_cross_example/models/appModel.dart';

BuildContext _mainContext;
void init(BuildContext c) => _mainContext = c;

// Provide quick lookup methods for all the top-level models and services.
class BaseCommand {
  // Models
  AppModel appModel = _mainContext.read();
  // Services
  // UserService userService = _mainContext.read();
}
