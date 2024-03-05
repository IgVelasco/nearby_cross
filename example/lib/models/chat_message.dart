import 'package:intl/intl.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/models/message_model.dart';

class ChatMessage extends NearbyMessage {
  bool received;
  String? sender;

  ChatMessage.fromString(String message,
      {messageType = NearbyMessageType.direct,
      this.received = false,
      this.sender})
      : super.fromString(message, messageType: messageType);

  ChatMessage.fromParent(NearbyMessage nm, {this.received = false, this.sender})
      : super(nm.convertToBytes());

  void setReceived(bool value) => received = value;

  String format({bool printSender = false}) {
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    if (printSender && sender != null) {
      return " ${(sender)} ${inputFormat.format(dateTime)} - ${BytesUtils.getString(message)}";
    }

    return "${inputFormat.format(dateTime)} - ${BytesUtils.getString(message)}";
  }
}
