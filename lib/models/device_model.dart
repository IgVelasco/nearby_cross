class Device {
  String endpointId;
  String endpointName;
  List<String> messages = [];

  Device(this.endpointId, this.endpointName);

  void addMessage(String message) {
    messages.add(message);
  }

  @override
  bool operator ==(other) => other is Device && endpointId == other.endpointId;

  @override
  int get hashCode => endpointId.hashCode;

  @override
  String toString() {
    return "{endpointId: $endpointId, endpointName: $endpointName}";
  }
}
