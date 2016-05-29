part of gcov.common;

abstract class GcovWriter {
  /// Endian of the writer
  bool get bigEndian;

  void writeText(String aStr);

  void writeChar(int aChar);

  void writeCharCodes(List<int> aChars) {
    for(int lData in aChars) {
      writeChar(lData);
    }
  }

  void writeUint8List(Uint8List aChars) {
    writeCharCodes(aChars.toList(growable: false));
  }

  void writeInt32(int aInt) {
    Uint8List lChars;

    if(bigEndian) {
      lChars = int32ToBigEndian(aInt);
    } else {
      lChars = int32ToLittleEndian(aInt);
    }

    writeUint8List(lChars);
  }

  void writeString(String aStr) {
    int lLen = (aStr.length/4).ceil();
    writeInt32(lLen);

    writeText(aStr);
    int lPadding = 4 - (aStr.length%4);

    if(lPadding != 4) {
      writeText(new String.fromCharCodes(new List.filled(lPadding, 0)));
    }
  }

  void writeVersion(GcovVersion aVer) {
    writeText(aVer.getByEndian(bigEndian));
  }
}

abstract class GcovWriterWithBuffer extends GcovWriter {
  StringBuffer get buffer;

  void writeText(String aStr) {
    buffer.write(aStr);
  }

  void writeChar(int aChar) {
    buffer.writeCharCode(aChar);
  }
}