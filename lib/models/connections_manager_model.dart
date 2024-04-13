import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jwk/jwk.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/constants/app.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/helpers/string_utils.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/models/peer_info_manager.dart';
import 'package:nearby_cross/models/signing_manager.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Class to manage conections coming from NearbyCross plugin
class ConnectionsManager {
  var logger = Logger();
  String identifier = const Uuid().v4();
  static ConnectionsManager? _singleton;
  NearbyCross nearbyCross = NearbyCross();
  Set<Device> pendingAcceptConnections = {};
  Set<Device> initiatedConnections = {};
  Set<Device> connectedDevices = {};
  late SigningManager signingManager;
  late AppMode appMode;
  PeerIdentifications? peerIdentifications;

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
  factory ConnectionsManager(
      {AppMode appMode = AppMode.experimental,
      PeerIdentifications? peerIdentifications,
      Map<String, String>? keyPairJwk}) {
    if (appMode != AppMode.experimental && peerIdentifications == null) {
      peerIdentifications =
          PeerIdentifications(); // Generate an empty peer identifications object
    }

    _singleton ??= ConnectionsManager._internal(appMode, peerIdentifications,
        keyPairJwk: keyPairJwk);

    return _singleton!;
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
  void _handleConnectionInitiated(
      String endpointId, String endpointName, bool alreadyAcceptedConnection) {
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

    if (appMode == AppMode.experimental) {
      // In experimental mode, the handshake message includes the public key to be used
      // for this device authentication
      var message =
          NearbyMessage.handshakeMessage(signingManager.convertPublicToJwk()!);
      device.sendMessage(message, dropMessage: true);
    } else {
      // If not in experimental mode, the handshake message includes the identifier for this
      // device, and the peer device must validate the signature of this message using a public
      // key obtained from a trustworthy source.
      var message = NearbyMessage.handshakeMessage(identifier);
      device.sendMessage(message, dropMessage: true);
    }
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
      addPublicKeyToDevice(endpointId, nearbyMessage);
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
  ConnectionsManager._internal(this.appMode, this.peerIdentifications,
      {Map<String, String>? keyPairJwk}) {
    if (keyPairJwk == null) {
      // If not receiving a JWK for a Key Pair to use, look for it in the local storage
      // If not found, generate a random key pair and store it in Local Storage for future use
      SharedPreferences.getInstance().then((prefs) async {
        var jwk = prefs.getString('signing_manager_jwk');
        if (jwk != null) {
          logger.i("Found Keys JWK. Starting Signing Manager from old config");
          var decoded = json.decode(jwk);
          signingManager = SigningManager.initializeFromJwk(decoded);
        } else {
          logger.i(
              "Old JWK Config not found. Starting a new instance for signing session");
          signingManager = SigningManager.initialize();
          var encoded = signingManager.convertToJwk();
          await prefs.setString('signing_manager_jwk', encoded!);
        }
      });
    } else {
      signingManager = SigningManager.initializeFromJwk(keyPairJwk);
    }

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.connectionInitiated,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = arguments["endpointId"] as String;
      var endpointName = arguments["endpointName"] as String;
      var alreadyAcceptedConnection =
          (arguments["alreadyAcceptedConnection"] as String).parseBool();
      return _handleConnectionInitiated(
          endpointId, endpointName, alreadyAcceptedConnection);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.successfulConnection,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = arguments["endpointId"] as String;
      return _handleSuccessfulConnection(endpointId);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.connectionRejected,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = arguments["endpointId"] as String;
      return _handleRejectedConnection(endpointId);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.payloadReceived,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var messageReceived = arguments["message"] as Uint8List;
      var endpointId = arguments["endpointId"] as String;

      return _handlePayloadReceived(endpointId, messageReceived);
    });
    nearbyCross.setMethodCallHandler(NearbyCrossMethods.endpointDisconnected,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      return _handleEndpointDisconnected(arguments["endpointId"] as String);
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
  Device addInitiatedConnection(String endpointId, String endpointName) {
    var device = Device(endpointId, endpointName);
    device.setSigner(signingManager);
    initiatedConnections.add(device);
    return device;
  }

  // Adds a device in initiatedConnections set.
  Device addDeviceAsInitiatedConnection(Device device) {
    initiatedConnections.add(device);
    return device;
  }

  /// Adds a device in pendingAcceptConnections set.
  Device addPendingAcceptConnection(String endpointId, String endpointName) {
    var device = Device.asPendingConnection(endpointId, endpointName);
    device.setSigner(signingManager);
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
    initiatedConnections.remove(endpointId);

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

  /// Adds message received to the device where it comes from.
  Device? addPublicKeyToDevice(String endpointId, NearbyMessage message) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e("Could not find device $endpointId");
      return null;
    }

    if (appMode == AppMode.experimental) {
      // In experimental mode, this handshake received message contains the public key
      // of the peer device that is connecting
      var verifier = SigningManager.initializeFromJwk(
          Jwk.fromUtf8(message.message).toJson());
      device.addVerifier(verifier);
    } else {
      // If not in experimental mode, this handshake received message contains the identifier
      // for the peer device. We must obtain its public key from a trustworthy source using this identifier.
      var peerInfo = peerIdentifications!
          .getPeerIdentification(BytesUtils.getString(message.message));
      var verifier = SigningManager.initializeFromJwk(peerInfo!);
      device.addVerifier(verifier);
    }
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

    var signature =
        signingManager.signMessage(BytesUtils.stringToBytesArray(message));
    var signedMessage = NearbyMessage.fromString(message, signature: signature);
    device.sendMessage(signedMessage);
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

  void setIdentifier(String newId) {
    identifier = newId;
  }

  void signingManagerFromJwk(Map<String, String> jwk) {
    signingManager = SigningManager.initializeFromJwk(jwk);
  }
}
