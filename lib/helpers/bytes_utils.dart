import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

extension Int8BytesAmount on Int8 {
  int getBytesAmount() {
    return 1;
  }
}

extension Int16BytesAmount on Int16 {
  int getBytesAmount() {
    return 2;
  }
}

extension Int32BytesAmount on Int32 {
  int getBytesAmount() {
    return 4;
  }
}

extension Int64BytesAmount on Int64 {
  int getBytesAmount() {
    return 8;
  }
}

abstract class BytesUtils {
  static Uint8List int64bytes(int value) =>
      Uint8List(8)..buffer.asInt64List()[0] = value;

  static Uint8List boolByte(bool value) =>
      Uint8List(1)..buffer.asInt8List()[0] = value ? 1 : 0;

  static int getInt8(List<int> value) =>
      Uint8List.fromList(value).buffer.asByteData().getInt8(0);

  static Uint8List stringToBytesArray(String value) =>
      Uint8List.fromList(value.codeUnits);

  static int getInt64(List<int> value) =>
      Uint8List.fromList(value).buffer.asByteData().getInt64(0, Endian.host);

  static String getString(List<int> value) => utf8.decode(value);

  static List<int> getBytesRangeAsIntList(
      Uint8List bytesList, int start, int bytesAmount) {
    return bytesList.getRange(start, start + bytesAmount).toList();
  }
}
