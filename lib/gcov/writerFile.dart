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
    List<int> lBuf = <int>[];
    _access.readIntoSync(lBuf, aStart, aEnd);
    return new String.fromCharCodes(lBuf);
  }
}
