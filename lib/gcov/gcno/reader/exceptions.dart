part of gcov.gcno.reader;

class FuncChkSumException {
  const FuncChkSumException._create();

  String toString() => "Function checksum doesn't match!";
}

class InvalidBlockException {
  const InvalidBlockException._create();

  String toString() => "Invalid block referenced!";
}