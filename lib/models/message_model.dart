import 'dart:ffi';
import 'dart:typed_data';

import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/modules/authentication/signing_manager.dart';

class NearbyMessageType {
  static const NearbyMessageType direct = NearbyMessageType(0);
  static const NearbyMessageType broadcast = NearbyMessageType(1);
  static const NearbyMessageType handshake = NearbyMessageType(2);

  final int type;

  const NearbyMessageType(this.type);

  static fromInt8(int value) {
    switch (value) {
      case 0:
        return NearbyMessageType.direct;
      case 1:
        return NearbyMessageType.broadcast;
      case 2:
        return NearbyMessageType.handshake;
      default:
        return NearbyMessageType(value);
    }
  }

  Uint8List toInt8() {
    var aux = Uint8List(1)..buffer.asInt8List();
    aux[0] = type;
    return aux;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NearbyMessageType && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

/*
* Converted:
* - messageType (1 int 8bit) + dateTime (1 int 64bit) + payloadSize (1 int 64bit) (N) + payload (N int 8bit) + signature (64 bytes)
*/
class NearbyMessage {
  late NearbyMessageType messageType;
  late DateTime dateTime;
  late int pSize;
  late Uint8List message;
  late Uint8List signature;
  bool isAuthenticated = false;

  NearbyMessage.fromBytes(this.message,
      {this.messageType = NearbyMessageType.direct, signature})
      : dateTime = DateTime.now(),
        pSize = message.length,
        signature = signature ?? Uint8List(0);

  NearbyMessage.fromString(String message,
      {this.messageType = NearbyMessageType.direct, signature})
      : dateTime = DateTime.now(),
        message = BytesUtils.stringToBytesArray(message),
        pSize = BytesUtils.stringToBytesArray(message).length,
        signature = signature ?? Uint8List(0);

  NearbyMessage.handshakeMessage(String handshakePayload, {signature})
      : messageType = NearbyMessageType.handshake,
        dateTime = DateTime.now(),
        message = BytesUtils.stringToBytesArray(handshakePayload),
        pSize = BytesUtils.stringToBytesArray(handshakePayload).length,
        signature = signature ?? Uint8List(0);

  NearbyMessage(Uint8List payload, {this.isAuthenticated = false}) {
    var boundary = 0;

    var messageTypeByte = BytesUtils.getBytesRangeAsIntList(
        payload, boundary, boundary += const Int8().getBytesAmount());
    messageType =
        NearbyMessageType.fromInt8(BytesUtils.getInt8(messageTypeByte));

    var dateTimeBytes = BytesUtils.getBytesRangeAsIntList(
        payload, boundary, const Int64().getBytesAmount());
    dateTime =
        DateTime.fromMillisecondsSinceEpoch(BytesUtils.getInt64(dateTimeBytes));
    boundary += const Int64().getBytesAmount();

    var pSizeBytes = BytesUtils.getBytesRangeAsIntList(
        payload, boundary, const Int64().getBytesAmount());
    pSize = BytesUtils.getInt64(pSizeBytes);
    boundary += const Int64().getBytesAmount();

    var messageBytes =
        BytesUtils.getBytesRangeAsIntList(payload, boundary, pSize);
    message = Uint8List.fromList(messageBytes);
    boundary += pSize;

    var signatureBytes = BytesUtils.getBytesRangeAsIntList(
        payload, boundary, payload.length - boundary);
    signature = Uint8List.fromList(signatureBytes);
  }

  Uint8List convertToBytes() {
    var messageTypeByte = messageType.toInt8();
    var dateTimeBytes = BytesUtils.int64bytes(dateTime.millisecondsSinceEpoch);
    var messageBytes = message;
    var messageBytesSize = BytesUtils.int64bytes(message.length);
    var signatureBytes = signature;

    BytesBuilder bb = BytesBuilder();
    bb.add(messageTypeByte);
    bb.add(dateTimeBytes);
    bb.add(messageBytesSize);
    bb.add(messageBytes);
    bb.add(signatureBytes);

    return bb.toBytes();
  }

  void signMessage(SigningManager signer) {
    var signature = signer.signMessage(message);
    if (signature == null) {
      this.signature = Uint8List(0);
    }

    this.signature = signature!.data;
  }

  void setIsAuthenticated(bool isAuth) {
    isAuthenticated = isAuth;
  }

  void validateAuthenticity(SigningManager verifier) {
    var messageIsValid = verifier.verifyMessage(message, signature);
    setIsAuthenticated(messageIsValid);
  }
}
