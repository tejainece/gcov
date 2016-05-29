library gcov.writer.IOSink;

import 'dart:io';
import 'dart:async';
import 'package:gcov/gcov/common/common.dart';

abstract class GcovWriterIOSink extends GcovWriter {
  IOSink get io;

  void writeText(String aStr) {
    io.add(aStr.codeUnits);
  }

  void writeChar(int aChar) {
    io.writeCharCode(aChar);
  }

  Future flush() async {
    await io.flush();
  }
}

class GcovReadHelperFile extends GcovReadHelper {
  final String filename;

  @override
  final bool bigEndian;

  RandomAccessFile _access;

  GcovReadHelperFile(this.bigEndian, this.filename) {
    File lFile = new File(filename);
    if(!lFile.existsSync()) {
      throw new Exception("File does not exist!");
    }
    _access = lFile.openSync();
  }

  int get contentLen {
    if (_access is! RandomAccessFile) {
      return 0;
    }

    return _access.lengthSync();
  }

  @override
  String getSubstring(int aStart, int aEnd) {
    int aLen = aEnd-aStart;
    List<int> lBuf = new List.filled(aLen, 0);
    _access.setPositionSync(aStart);
    _access.readIntoSync(lBuf, 0, aLen);
    return new String.fromCharCodes(lBuf);
  }
}
