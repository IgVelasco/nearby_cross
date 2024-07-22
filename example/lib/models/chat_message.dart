import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/models/message_model.dart';

class ChatMessage extends NearbyMessage {
  bool received;
  Uint8List? sender;

  ChatMessage.fromString(
    String message, {
    messageType = NearbyMessageType.direct,
    this.received = false,
    this.sender,
  }) : super.fromString(message, messageType: messageType);

  ChatMessage.fromParent(NearbyMessage nm,
      {this.received = false, this.sender, isAuthenticated = false})
      : super(nm.convertToBytes(), isAuthenticated: isAuthenticated);

  void setReceived(bool value) => received = value;

  String format({bool printSender = false}) {
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var authBadge = isAuthenticated ? '✅' : '❌';
    if (printSender && sender != null) {
      return "${received ? authBadge : ''} ${BytesUtils.getString(sender!)} ${inputFormat.format(dateTime)} - ${BytesUtils.getString(message)}";
    }

    return "${received ? authBadge : ''} ${inputFormat.format(dateTime)} - ${BytesUtils.getString(message)}";
  }
}
