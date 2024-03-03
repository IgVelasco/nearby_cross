import 'dart:collection';

import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:nearby_cross/types/item_type.dart';

/// Class that represent every connected device with NearbyCross plugin
class Device {
  String endpointId;
  String endpointName;
  bool isEndpointOnly;
  bool isPendingConnection;
  List<NearbyMessage> messages = [];
  List<NearbyMessage> messagesSent = [];
  final NearbyCross _nearbyCross = NearbyCross();
  Function(Device) callbackReceivedMessage = (_) => {};

  Device(this.endpointId, this.endpointName)
      : isEndpointOnly = false,
        isPendingConnection = false;

  Device.asEndpoint(this.endpointId, this.endpointName)
      : isEndpointOnly = true,
        isPendingConnection = false;

  Device.asPendingConnection(this.endpointId, this.endpointName)
      : isEndpointOnly = false,
        isPendingConnection = true;

  /// Sets callbackReceivedMessage callback that executes every time a message is received.
  void setCallbackReceivedMessage(Function(Device) callbackReceivedMessage) {
    this.callbackReceivedMessage = callbackReceivedMessage;
  }

  /// Adds message to received messages list
  void addMessage(NearbyMessage message) {
    if (!isEndpointOnly) {
      messages.add(message);
      callbackReceivedMessage(this);
    }
  }

  /// Sends message to the device identified with endpointId
  void sendMessage(NearbyMessage message) {
    messagesSent.add(message);
    _nearbyCross.sendData(message.convertToBytes(), endpointId);
  }

  /// Retrieves message and messageSent list
  List<NearbyMessage> getAllMessages() {
    List<NearbyMessage> combined = [...messages, ...messagesSent];
    combined.sort(((a, b) => a.dateTime.compareTo(a.dateTime)));
    return combined;
  }

  /// Retrieves messages sent list
  List<NearbyMessage> getMessagesSent() {
    return messagesSent;
  }

  /// Retrieves messages received list
  List<NearbyMessage> getMessagesReceived() {
    return messages;
  }

  /// Retrieves last message received
  NearbyMessage? getLastMessage() {
    try {
      return messages.last;
    } catch (_) {
      return null;
    }
  }

  Item toItem() {
    return HashMap.from(
        {"endpointId": endpointId, "endpointName": endpointName});
  }

  void clearMessages() {
    messages.clear();
    messagesSent.clear();
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
