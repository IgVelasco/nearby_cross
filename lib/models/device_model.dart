class Device {
  String endpointId;
  String endpointName;
  List<String> messages = [];

  Device(this.endpointId, this.endpointName);

  void addMessage(String message) {
    messages.add(message);
  }
}
