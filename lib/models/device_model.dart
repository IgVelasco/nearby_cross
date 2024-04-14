import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/models/signing_manager.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:nearby_cross/types/item_type.dart';
import 'package:uuid/uuid.dart';

/// Class that represent every connected device with NearbyCross plugin
class Device {
  Logger logger = Logger();
  String identifier = const Uuid().v4();
  String endpointId;
  String endpointName;
  bool isEndpointOnly;
  bool isPendingConnection;
  bool hasNewMessages = false;
  List<NearbyMessage> messages = [];
  List<NearbyMessage> messagesSent = [];
  final NearbyCross _nearbyCross = NearbyCross();
  HashMap<String, dynamic Function(Device)> callbackReceivedMessage =
      HashMap<String, dynamic Function(Device)>();
  SigningManager? verifier;
  SigningManager? signer;
  bool isAuthenticated = false;

  Device(this.endpointId, this.endpointName)
      : isEndpointOnly = false,
        isPendingConnection = false;

  Device.asEndpoint(this.endpointId, this.endpointName)
      : isEndpointOnly = true,
        isPendingConnection = false;

  Device.asPendingConnection(this.endpointId, this.endpointName)
      : isEndpointOnly = false,
        isPendingConnection = true;

  void setSigner(SigningManager signer) {
    this.signer = signer;
  }

  void setIdentifier(String newId) {
    identifier = newId;
  }

  void setIsAuthenticated(bool isAuth) {
    isAuthenticated = isAuth;
  }

  /// Sets callbackReceivedMessage callback that executes every time a message is received.
  void setCallbackReceivedMessage(
      String callbackName, Function(Device) callbackReceivedMessage) {
    this.callbackReceivedMessage[callbackName] = callbackReceivedMessage;
  }

  /// Unset callbackReceivedMessage
  void unsetCallbackReceivedMessage(String callbackKey) {
    callbackReceivedMessage.remove(callbackKey);
  }

  void _executeCallback(
      HashMap<String, dynamic Function(Device)> callbackCollection,
      Device funcParam) {
    for (var callbackKey in callbackCollection.keys) {
      try {
        callbackCollection[callbackKey]!(funcParam);
      } on FlutterError catch (err) {
        // Disposed ChangeNotifier
        logger.e(
            "Could not execute callback $callbackKey. Error: ${err.toString()}");
        callbackCollection.remove(callbackKey);
      } catch (err) {
        logger.e(
            "Could not execute callback $callbackKey. Error: ${err.toString()}");
      }
    }
  }

  void addVerifier(SigningManager verifier) {
    this.verifier = verifier;
  }

  bool validateMessageOwner(NearbyMessage message) {
    try {
      return verifier!.verifyMessage(message.message, message.signature);
    } catch (e) {
      logger.e("Could not validate message owner: $e");
      return false;
    }
  }

  /// Adds message to received messages list
  void addMessage(NearbyMessage message) {
    if (!isEndpointOnly) {
      var messageIsValid = validateMessageOwner(message);
      message.setIsAuthenticated(messageIsValid);
      if (!messageIsValid) {
        logger.e("Received message is not from an authenticated third-paty!");
      } else {
        logger.d("Received message is authenticated!");
      }

      messages.add(message);

      _executeCallback(callbackReceivedMessage, this);
      hasNewMessages = true;
    }
  }

  /// Sends message to the device identified with endpointId
  void sendMessage(NearbyMessage message, {bool dropMessage = false}) {
    if (signer != null) {
      message.signMessage(signer!);
    }

    if (!dropMessage) {
      messagesSent.add(message);
    }
    _nearbyCross.sendData(message.convertToBytes(), endpointId);
  }

  /// Retrieves message and messageSent list
  List<NearbyMessage> getAllMessages() {
    List<NearbyMessage> combined = [...messages, ...messagesSent];
    combined.sort(((a, b) => a.dateTime.compareTo(a.dateTime)));
    hasNewMessages = false;
    return combined;
  }

  /// Retrieves messages sent list
  List<NearbyMessage> getMessagesSent() {
    return messagesSent;
  }

  /// Retrieves messages received list
  List<NearbyMessage> getMessagesReceived() {
    hasNewMessages = false;
    return messages;
  }

  /// Retrieves last message received
  NearbyMessage? getLastMessage() {
    hasNewMessages = false;
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
