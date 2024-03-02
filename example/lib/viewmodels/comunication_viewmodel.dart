import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';

class ComunicationViewModel extends ChangeNotifier {
  Device connectedDevice;
  NearbyMessage? lastMessage;
  Logger logger = Logger();

  ComunicationViewModel(this.connectedDevice) {
    var connectionsManager = ConnectionsManager();

    connectionsManager.setCallbackReceivedMessage(
        connectedDevice.endpointId, _callbackReceivedMessage);

    var asd = NearbyMessage.fromString("HOLA");
    var converted = asd.convertToBytes();

    var jaja = NearbyMessage(converted);

    logger.i("Message type: ${jaja.messageType}");
    logger.i("Date time: ${jaja.dateTime}");
    logger.i("Message: ${jaja.message}");
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackReceivedMessage(Device device) {
    lastMessage = device.getLastMessage();
    _commonCallback(device);
  }

  String? getConnectedDeviceName() {
    return connectedDevice.endpointName;
  }

  void sendData(String message) {
    connectedDevice.sendMessage(NearbyMessage.fromString(message));
  }

  NearbyMessage? getLastMessage() {
    return lastMessage;
  }

  List<String> getLastMessages() {
    return connectedDevice.messages
        .map((m) => "${m.dateTime} - ${BytesUtils.getString(m.message)}")
        .toList();
  }

  int getMessagesCount() {
    return connectedDevice.messages.length;
  }

  void clearMessages() {
    connectedDevice.clearMessages();
    notifyListeners();
  }
}
