part of gcov.common;

/// \brief Exception thrown when the content length is
/// less than required
class LengthException {
  const LengthException(this.req, this.present);

  final int req;

  final int present;

  String toString() =>
      "Content length not enough! Required ${req}, but only has ${present}.";
}

abstract class GcovReader {
  GcovReadHelper get helper;

  bool hasHeader() {
    return helper.hasEnoughLen(12);
  }

  int getFormat() {
    hasHeader() ? true : throw new LengthException(4, helper.contentLen);

    return helper.getInt32At(0);
  }

  String getFormatStr() {
    return int32ToString(getFormat());
  }

  int getVersion() {
    hasHeader() ? true : throw new LengthException(8, helper.contentLen);

    return helper.getInt32At(4);
  }

  String getVersionStr() {
    return int32ToString(getVersion());
  }

  int getChecksum() {
    hasHeader() ? true : throw new LengthException(12, helper.contentLen);

    return helper.getInt32At(8);
  }

  bool isFormatValid();

  bool isVersionValid() {
    if (!hasHeader()) {
      return false;
    }

    if (!GCOV_VERSIONS_VALID.contains(getVersionStr())) {
      return false;
    }

    return true;
  }
}

abstract class GcovReadHelper {
  bool get bigEndian;

  int get contentLen;

  int getInt64At(int aPos) {
    int lLow = getInt32At(aPos);
    int lHigh = getInt32At(aPos+4);

    return (lHigh << 32) | lLow;
  }

  int getInt32At(int aPos) {
    String lStr = getSubstring(aPos, aPos + 4);

    if (bigEndian) {
      return bigEndianStrToInt32(lStr, 0);
    } else {
      return littleEndianStrToInt32(lStr, 0);
    }
  }

  String getSubstring(int aStart, int aEnd);

  Tuple2<int, String> getGCovString(int aPos) {
    int lOffset = 0;
    int lLen;
    do {
      lLen = getInt32At(aPos + lOffset);

      lOffset += 4;
    } while (lLen == 0);

    lLen *= 4;

    String lStr = getSubstring(aPos + lOffset, aPos + lOffset + lLen);
    lOffset += lLen;

    while (lStr.codeUnitAt(lStr.length - 1) == 0) {
      lStr = lStr.substring(0, lStr.length - 1);
    }

    return new Tuple2<int, String>(lOffset, lStr);
  }

  bool hasEnoughLen(int aLen) {
    return contentLen >= aLen;
  }
}

class GcovReadHelperStr extends GcovReadHelper {
  /// \brief content of the file
  String _content;

  @override
  final bool bigEndian;

  GcovReadHelperStr(this.bigEndian, this._content);

  @override
  int get contentLen {
    if (_content is! String) {
      return 0;
    }

    return _content.length;
  }

  @override
  String getSubstring(int aStart, int aEnd) {
    return _content.substring(aStart, aEnd);
  }
}
