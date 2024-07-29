import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/helpers/string_utils.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/modules/authentication/authentication_manager.dart';
import 'package:nearby_cross/modules/authentication/signing_manager.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';

/// Class to manage conections coming from NearbyCross plugin
class ConnectionsManager {
  var logger = Logger();
  static ConnectionsManager? _singleton;
  late NearbyCross nearbyCross;
  Set<Device> pendingAcceptConnections = {};
  Set<Device> initiatedConnections = {};
  Set<Device> connectedDevices = {};

  AuthenticationManager? authenticationManager;

  HashMap<String, dynamic Function(Device)> callbackPendingAcceptConnection =
      HashMap<String, dynamic Function(Device)>();
  HashMap<String, dynamic Function(Device)> callbackConnectionRejected =
      HashMap<String, dynamic Function(Device)>();
  HashMap<String, dynamic Function(Device)> callbackConnectionInitiated =
      HashMap<String, dynamic Function(Device)>();
  HashMap<String, dynamic Function(Device)> callbackDisconnectedDevice =
      HashMap<String, dynamic Function(Device)>();
  HashMap<String, dynamic Function(Device)> callbackSuccessfulConnection =
      HashMap<String, dynamic Function(Device)>();
  HashMap<String, dynamic Function(Device)> callbackReceivedMessage =
      HashMap<String, dynamic Function(Device)>();

  /// ConnectionsManager implements the singleton pattern.
  /// There will be only one instance of this class
  factory ConnectionsManager({AuthenticationManager? authenticationManager}) {
    _singleton ??= ConnectionsManager._internal(authenticationManager);

    return _singleton!;
  }

  /// Destroys the singleton instance, allowing to create a new one
  static void destroy() {
    NearbyCross.destroy();
    _singleton = null;
  }

  /// Removes a named callback in all callback collections
  void removeNamedCallback(String callbackKey) {
    // TODO: Find a better way to do this
    callbackPendingAcceptConnection.remove(callbackKey);
    callbackConnectionRejected.remove(callbackKey);
    callbackConnectionInitiated.remove(callbackKey);
    callbackDisconnectedDevice.remove(callbackKey);
    callbackSuccessfulConnection.remove(callbackKey);
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

  /// Handler for [NearbyCrossMethods.connectionInitiated] method call.
  /// Adds a device as a "initiated connection", waiting for the conection to sucess.
  void _handleConnectionInitiated(String endpointId, Uint8List endpointName,
      bool alreadyAcceptedConnection) {
    logger.d(
        "Connecting endpoint $endpointId with ${endpointName.length} bytes as device info");
    if (alreadyAcceptedConnection) {
      var device = addInitiatedConnection(endpointId, endpointName);
      _executeCallback(callbackConnectionInitiated, device);
    } else {
      var device = addPendingAcceptConnection(endpointId, endpointName);
      _executeCallback(callbackPendingAcceptConnection, device);
    }
  }

  /// Handler for [NearbyCrossMethods.endpointDisconnected] method call.
  /// Adds a device as a "initiated connection", waiting for the conection to sucess.
  void _handleEndpointDisconnected(String endpointId) {
    var device = removeConnectedDevices(endpointId);
    logger.d("Disconnected endpoint $endpointId");
    if (device != null) {
      _executeCallback(callbackDisconnectedDevice, device);
    }
  }

  /// Handler for [NearbyCrossMethods.successfulConnection] method call.
  /// Moves device to connectedDevices set, marking it as a completed connection ready to use
  void _handleSuccessfulConnection(String endpointId) {
    var device = addConnectedDevice(endpointId);
    if (device == null) {
      return;
    }

    authenticationManager?.startHandshake(device);

    logger.d("Device ${device.endpointName} is successfully connected");
    _executeCallback(callbackSuccessfulConnection, device);
  }

  void _handleRejectedConnection(String endpointId) {
    var device = _findDevice(pendingAcceptConnections, endpointId);
    if (device == null) {
      return;
    }

    pendingAcceptConnections.remove(device);
    _executeCallback(callbackConnectionRejected, device);
  }

  /// Handler for [NearbyCrossMethods.payloadReceived] method call.
  /// Adds received message to the corresponding device.
  void _handlePayloadReceived(String endpointId, Uint8List messageReceived) {
    var nearbyMessage = NearbyMessage(messageReceived);

    if (nearbyMessage.messageType == NearbyMessageType.handshake) {
      enterHandshakeProcess(endpointId, nearbyMessage);
      return;
    }

    var device = addMessageFromDevice(endpointId, nearbyMessage);
    if (device == null) {
      return;
    }

    _executeCallback(callbackReceivedMessage, device);
  }

  /// Internal constructor for class [ConnectionsManager].
  /// Sets method call handlers for [NearbyCrossMethods.connectionInitiated], [NearbyCrossMethods.successfulConnection] and [NearbyCrossMethods.payloadReceived]
  ConnectionsManager._internal(this.authenticationManager) {
    authenticationManager?.initialize();
    nearbyCross = NearbyCross();

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.connectionInitiated,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = utf8.decode(arguments["endpointId"] as Uint8List);
      var endpointName = arguments["endpointName"] as Uint8List;
      var alreadyAcceptedConnection =
          (utf8.decode(arguments["alreadyAcceptedConnection"] as Uint8List))
              .parseBool();
      return _handleConnectionInitiated(
          endpointId, endpointName, alreadyAcceptedConnection);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.successfulConnection,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = utf8.decode(arguments["endpointId"] as Uint8List);
      return _handleSuccessfulConnection(endpointId);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.connectionRejected,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = utf8.decode(arguments["endpointId"] as Uint8List);
      return _handleRejectedConnection(endpointId);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.payloadReceived,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = utf8.decode(arguments["endpointId"] as Uint8List);
      var messageReceived = arguments["message"] as Uint8List;

      return _handlePayloadReceived(endpointId, messageReceived);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.endpointDisconnected,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = utf8.decode(arguments["endpointId"] as Uint8List);
      return _handleEndpointDisconnected(endpointId);
    });
  }

  /// Sets callbackConnectionInitiated callback that executes every time a connection is initiated.
  void setCallbackConnectionInitiated(
      String callbackId, Function(Device) callbackConnectionInitiated) {
    this.callbackConnectionInitiated[callbackId] = callbackConnectionInitiated;
  }

  /// Sets callbackConnectionRejected callback that executes every time a connection is rejected.
  void setCallbackConnectionRejected(
      String callbackId, Function(Device) callbackConnectionRejected) {
    this.callbackConnectionRejected[callbackId] = callbackConnectionRejected;
  }

  /// Sets callbackConnectionInitiated callback that executes every time a connection needs to be accepted.
  void setCallbackPendingAcceptConnection(
      String callbackId, Function(Device) callbackPendingAcceptConnection) {
    this.callbackPendingAcceptConnection[callbackId] =
        callbackPendingAcceptConnection;
  }

  /// Sets callbackSuccessfulConnection callback that executes every time a connection successfully finishes.
  void setCallbackSuccessfulConnection(
      String callbackId, Function(Device) callbackSuccessfulConnection) {
    this.callbackSuccessfulConnection[callbackId] =
        callbackSuccessfulConnection;
  }

  /// Sets callbackReceivedMessage callback that executes every time a device receives a message.
  void setCallbackReceivedMessage(
      String callbackId, Function(Device) callbackReceivedMessage) {
    this.callbackReceivedMessage[callbackId] = callbackReceivedMessage;
  }

  /// Sets callbackDisconnectedDevice that executes every time a device is disconnected
  void setCallbackDisconnectedDevice(
      String callbackId, Function(Device) callbackDisconnectedDevice) {
    this.callbackDisconnectedDevice[callbackId] = callbackDisconnectedDevice;
  }

  /// Sets callbackReceivedMessage callback for a given device that executes every time a message is received from that device.
  void setCallbackReceivedMessageForDevice(
      String endpointId, Function(Device) callbackReceivedMessage,
      {String callbackName = "ConnectionsManager:receivedMessageForDevice"}) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e(
          "Could not set callback for received message because device $endpointId is neither connected nor active");
      return;
    }

    device.setCallbackReceivedMessage(callbackName, callbackReceivedMessage);
  }

  /// Unsets a received message callback for a given Device endpointId
  void unsetCallbackReceivedMessageForDevice(String endpointId,
      {String callbackName = "ConnectionsManager:receivedMessageForDevice"}) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device != null) {
      device.unsetCallbackReceivedMessage(callbackName);
    }
  }

  /// Private method to find a Device in a given iterable context.
  Device? _findDevice(Iterable iterable, String endpointId) {
    try {
      Device device =
          iterable.firstWhere((device) => device.endpointId == endpointId);
      return device;
    } catch (_) {
      return null;
    }
  }

  /// Creates a device in initiatedConnections set.
  Device addInitiatedConnection(String endpointId, Uint8List endpointName) {
    var device = Device(endpointId, endpointName);
    initiatedConnections.add(device);
    return device;
  }

  // Adds a device in initiatedConnections set.
  Device addDeviceAsInitiatedConnection(Device device) {
    initiatedConnections.add(device);
    return device;
  }

  /// Adds a device in pendingAcceptConnections set.
  Device addPendingAcceptConnection(String endpointId, Uint8List endpointName) {
    var device = Device.asPendingConnection(endpointId, endpointName);
    pendingAcceptConnections.add(device);
    return device;
  }

  /// Adds a device in connectedDevices set, removing it from initiatedConnections set after.
  Device? addConnectedDevice(String endpointId) {
    Device? device = _findDevice(initiatedConnections, endpointId);
    if (device == null) {
      logger.e(
          "Could not find a initiated connection from endpointID $endpointId");
      return null;
    }

    connectedDevices.add(device);
    initiatedConnections.remove(device);

    if (device.isPendingConnection) {
      pendingAcceptConnections.remove(device);
    }

    return device;
  }

  Device? removeConnectedDevices(String endpointId) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e(
          "Could not find a initiated connection from endpointID $endpointId");
      return device;
    }

    connectedDevices.remove(device);
    logger.i("Device $endpointId disconnected");
    return device;
  }

  /// Enters into handshaking process. See docs for reference.
  Device? enterHandshakeProcess(String endpointId, NearbyMessage message) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e("Could not find device $endpointId");
      return null;
    }

    authenticationManager?.processHandshake(device, message);

    return device;
  }

  /// Adds message received to the device where it comes from.
  Device? addMessageFromDevice(String endpointId, NearbyMessage message) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e("Could not find device $endpointId");
      return null;
    }

    device.addMessage(message);
    return device;
  }

  /// Sends message to a given device given its endpointId
  void sendMessageToDevice(String endpointId, String message) async {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e("Could not find device $endpointId");
      return;
    }

    var nbMessage = NearbyMessage.fromString(message);
    authenticationManager?.sign(nbMessage);
    device.sendMessage(nbMessage);
  }

  /// Broadcasts a message to every connected device
  void broadcastMessage(NearbyMessage message) {
    for (var device in connectedDevices) {
      device.sendMessage(message);
    }
  }

  /// Return Device with endpointId
  Device? getConnectedDevice(String endpointId) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e("Could not find device $endpointId");
      return null;
    }

    return device;
  }

  /// Return a list with all connected Devices
  List<Device> getAllConnectedDevices() {
    return connectedDevices.toList();
  }

  /// Accepts a pending connection
  Future<void> acceptConnection(String endpointId) async {
    var pending = _findDevice(pendingAcceptConnections, endpointId);
    if (pending == null) {
      return;
    }

    var device = addDeviceAsInitiatedConnection(pending);

    await nearbyCross.acceptConnection(endpointId);

    _executeCallback(callbackConnectionInitiated, device);
  }

  /// Rejects a pending connection
  Future<void> rejectConnection(String endpointId) async {
    var pending = _findDevice(pendingAcceptConnections, endpointId);
    if (pending == null) {
      return;
    }

    await nearbyCross.rejectConnection(endpointId);
    pendingAcceptConnections.remove(pending);

    _executeCallback(callbackConnectionRejected, pending);
  }

  /// Disconnects from a given device by its endpointId
  Future<void> disconnectFromEndpoint(String endpointId) async {
    var connectedDevice = _findDevice(connectedDevices, endpointId);
    if (connectedDevice == null) {
      return;
    }

    await nearbyCross.disconnectFrom(endpointId);
  }

  // TODO Signing: Refactor this
  Uint8List signDeviceInfo(String deviceInfo) {
    var signature = authenticationManager!.signingManager
        .signMessage(BytesUtils.stringToBytesArray(deviceInfo));

    BytesBuilder bb = BytesBuilder();
    bb.add(BytesUtils.stringToBytesArray(deviceInfo));
    bb.add(signature!.data);

    return bb.toBytes();
  }

  SigningManager? getSigningManager() {
    return authenticationManager?.signingManager;
  }
}
