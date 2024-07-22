import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross_example/constants/app.constants.dart';
import 'package:nearby_cross_example/models/chat_message.dart';

class BroadcastViewModel extends ChangeNotifier {
  Logger logger = Logger();
  late ConnectionsManager connectionsManager;
  List<ChatMessage> allMessages = [];

  BroadcastViewModel() {
    connectionsManager = ConnectionsManager();

    connectionsManager.setCallbackReceivedMessage(
        "BroadcastViewModel:receivedMessage", _callbackReceivedMessage);
  }

  @override
  void dispose() {
    connectionsManager
        .removeNamedCallback("BroadcastViewModel:receivedMessage");
    super.dispose();
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  Uint8List getEndpointNameFromDevice(Device device) {
    var fullDeviceInfo = device.endpointName;
    var indexSeparator = fullDeviceInfo.indexOf(AppConstants.separatorByte);
    if (indexSeparator == -1) {
      return fullDeviceInfo;
    }
    var deviceName = fullDeviceInfo.sublist(0, indexSeparator);
    return deviceName;
  }

  void _callbackReceivedMessage(Device device) {
    var message = ChatMessage.fromParent(device.getLastMessage()!,
        received: true,
        sender: getEndpointNameFromDevice(device),
        isAuthenticated: device.lastMassageIsAuthenticated());
    allMessages.add(message);
    _commonCallback(device);
  }

  int getMessagesCount() {
    return allMessages.length;
  }

  List<ChatMessage> getMessages() {
    return allMessages;
  }

  void clearMessages() {
    allMessages.clear();
    notifyListeners();
  }

  void broadcastMessage(String message) {
    ChatMessage messageToSend = ChatMessage.fromString(message,
        messageType: NearbyMessageType.broadcast, received: false);
    allMessages.add(messageToSend);

    connectionsManager.broadcastMessage(messageToSend);
    notifyListeners();
  }
}
