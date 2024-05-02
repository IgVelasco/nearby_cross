import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross_example/models/chat_message.dart';

class ComunicationViewModel extends ChangeNotifier {
  Device connectedDevice;
  Logger logger = Logger();
  late List<ChatMessage> allMessages;

  ComunicationViewModel(this.connectedDevice) {
    var connectionsManager = ConnectionsManager();

    connectionsManager.setCallbackReceivedMessageForDevice(
        connectedDevice.endpointId, _callbackReceivedMessage,
        callbackName: "ComunicationViewModel:receivedMessageForDevice");

    allMessages = [
      ...connectedDevice
          .getMessagesReceived()
          .map((nm) => ChatMessage.fromParent(nm,
              received: true, isAuthenticated: nm.isAuthenticated))
          .toList(),
      ...connectedDevice
          .getMessagesSent()
          .map((nm) => ChatMessage.fromParent(nm,
              received: false, isAuthenticated: nm.isAuthenticated))
          .toList()
    ];
    allMessages.sort(((a, b) => a.dateTime.compareTo(b.dateTime)));
  }

  @override
  void dispose() {
    var connectionsManager = ConnectionsManager();
    connectionsManager.unsetCallbackReceivedMessageForDevice(
        connectedDevice.endpointId,
        callbackName: "ComunicationViewModel:receivedMessageForDevice");
    super.dispose();
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackReceivedMessage(Device device) {
    NearbyMessage? lastMessage = device.getLastMessage();
    if (lastMessage != null) {
      allMessages.add(ChatMessage.fromParent(lastMessage,
          received: true, isAuthenticated: lastMessage.isAuthenticated));
    }
    _commonCallback(device);
  }

  Uint8List? getConnectedDeviceName() {
    return connectedDevice.endpointName;
  }

  void sendData(String message) {
    ChatMessage messageToSend =
        ChatMessage.fromString(message, received: false);
    allMessages.add(messageToSend);
    connectedDevice.sendMessage(messageToSend);
    notifyListeners();
  }

  List<ChatMessage> getMessages() {
    return allMessages;
  }

  int getMessagesCount() {
    return allMessages.length;
  }

  void clearMessages() {
    allMessages.clear();
    connectedDevice.clearMessages();
    notifyListeners();
  }
}
