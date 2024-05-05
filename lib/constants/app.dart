enum AppMode { experimental, testing, production }

extension AppModeString on AppMode {
  static AppMode match(String appModeStr) {
    switch (appModeStr) {
      case "experimental":
        return AppMode.experimental;
      case "production":
        return AppMode.production;
      case "testing":
        return AppMode.testing;
      default:
        return AppMode.experimental;
    }
  }
}
