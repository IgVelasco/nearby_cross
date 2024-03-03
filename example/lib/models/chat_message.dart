import 'package:intl/intl.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/models/message_model.dart';

class ChatMessage extends NearbyMessage {
  bool received;

  ChatMessage.fromString(String message,
      {messageType = NearbyMessageType.direct, this.received = false})
      : super.fromString(message, messageType: messageType);

  ChatMessage.fromParent(NearbyMessage nm, {this.received = false})
      : super(nm.convertToBytes());

  void setReceived(bool value) => received = value;

  String format() {
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    return "${inputFormat.format(dateTime)} - ${BytesUtils.getString(message)}";
  }
}
