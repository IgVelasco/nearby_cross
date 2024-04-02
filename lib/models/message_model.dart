import 'dart:ffi';
import 'dart:typed_data';

import 'package:nearby_cross/helpers/bytes_utils.dart';

enum NearbyMessageType {
  direct,
  broadcast;

  static fromInt8(int value) {
    switch (value) {
      case 0:
        return NearbyMessageType.direct;
      case 1:
        return NearbyMessageType.broadcast;
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
    }
  }
}

/*
* Converted:
* - messageType (1 int 8bit) + dateTime (1 int 64bit) + payload (N int 8bit)
*/
class NearbyMessage {
  late NearbyMessageType messageType; // 0 direct, 1 broadcast
  late DateTime dateTime;
  late Uint8List message;

  NearbyMessage.fromString(String message,
      {this.messageType = NearbyMessageType.direct})
      : dateTime = DateTime.now(),
        message = BytesUtils.stringToBytesArray(message);

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

    var messageBytes = BytesUtils.getBytesRangeAsIntList(
        payload, boundary, payload.length - boundary);
    message = Uint8List.fromList(messageBytes);
  }

  Uint8List convertToBytes() {
    var messageTypeByte = messageType.toInt8();
    var dateTimeBytes = BytesUtils.int64bytes(dateTime.millisecondsSinceEpoch);
    var messageBytes = message;

    BytesBuilder bb = BytesBuilder();
    bb.add(messageTypeByte);
    bb.add(dateTimeBytes);
    bb.add(messageBytes);

    return bb.toBytes();
  }

  @override
  String toString() {
    return String.fromCharCodes(message);
  }
}
