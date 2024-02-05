extension BoolParsing on String {
  bool parseBool() {
    return int.tryParse(this) == 1;
  }
}
