import 'package:nearby_cross/nearby_cross.dart';

class Device {
  String endpointId;
  String endpointName;
  List<String> messages = [];
  final NearbyCross _nearbyCross = NearbyCross();

  Device(this.endpointId, this.endpointName);

  void addMessage(String message) {
    messages.add(message);
  }

  void sendMessage(String message) {
    _nearbyCross.sendData(message, endpointId);
  }

  List<String> getMessages() {
    return messages;
  }

  String? getLastMessage() {
    try {
      return messages.last;
    } catch (_) {
      return null;
    }
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
