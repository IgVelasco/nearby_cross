class DeviceInfoTooLarge implements Exception {
  final int allowedBytes;
  const DeviceInfoTooLarge(this.allowedBytes);

  @override
  String toString() => "DeviceInfoTooLarge: Allowed bytes $allowedBytes";
}
