import 'dart:ffi';
import 'dart:typed_data';

import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/models/signing_manager.dart';

enum NearbyMessageType {
  direct,
  broadcast,
  handshake;

  static fromInt8(int value) {
    switch (value) {
      case 0:
        return NearbyMessageType.direct;
      case 1:
        return NearbyMessageType.broadcast;
      case 2:
        return NearbyMessageType.handshake;
      default:
        throw UnimplementedError();
    }
  }
}

extension NearbyMessageTypeInt on NearbyMessageType {
  Uint8List toInt8() {
    var aux = Uint8List(1)..buffer.asInt8List();
    switch (this) {
      case NearbyMessageType.direct:
        aux[0] = 0;
        return aux;
      case NearbyMessageType.broadcast:
        aux[0] = 1;
        return aux;
      case NearbyMessageType.handshake:
        aux[0] = 2;
        return aux;
    }
  }
}

/*
* Converted:
* - messageType (1 int 8bit) + dateTime (1 int 64bit) + payloadSize (1 int 64bit) (N) + payload (N int 8bit)
*/
class NearbyMessage {
  late NearbyMessageType messageType; // 0 direct, 1 broadcast
  late DateTime dateTime;
  late int pSize;
  late Uint8List message;
  late Uint8List signature;

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

  NearbyMessage(Uint8List payload) {
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
}
