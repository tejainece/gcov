library gcov.gcda.reader;

import 'package:tuple/tuple.dart';
import 'package:gcov/gcov/common/common.dart';

class GcdaReader extends GcovReader {
  final bool bigEndian;

  final GcovReadHelper helper;

  GcdaReader(this.bigEndian, this.helper);

  bool isFormatValid() {
    if (!hasHeader()) {
      return false;
    }

    if (getFormat() != GCDA_FORMAT) {
      return false;
    }

    return true;
  }

  dynamic parse() {
    if(!hasHeader()) {
      throw new LengthException(12, helper.contentLen);
    }

    if (!isFormatValid()) {
      throw invalidFormatErr;
    }

    if (!isVersionValid()) {
      throw unsupportedVersionErr;
    }

    int lPos = GCNO_HEADER_LEN;
    while(helper.hasEnoughLen(lPos + 4)) {
      int bTag = helper.getInt32At(lPos);
      lPos += 4;

      if(bTag == GCOV_TAG_OBJECT_SUMMARY) {
        var bObj = _parseObjectTag(lPos);
        lPos += bObj.item1;
      } else if(bTag == GCOV_TAG_PROGRAM_SUMMARY) {
        var bProg = _parseProgramTag(lPos);
        lPos += bProg.item1;
      } else if(bTag == GCOV_FUNCTION_TAG) {
        var bFunc = _parseFunctionTag(lPos);
        lPos += bFunc.item1;
      } else if(bTag == 0) {

      } else {
        throw new Exception("Unknown tag: ${bTag}!");
      }
    }

    //TODO
  }

  Tuple2<int, dynamic> _parseFunctionTag(int aPos) {
    int lOffset = 0;
    int lLen = helper.getInt32At(aPos + lOffset);
    if (!helper.hasEnoughLen(aPos + lLen)) {
      throw new LengthException(aPos + lLen, helper.contentLen);
    }
    lOffset += 4;

    int lIdentifier = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    int lCSum = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    //TODO config checksum?
    lOffset += 4;

    while(helper.hasEnoughLen(aPos + lOffset)) {
      int bTag = helper.getInt32At(aPos + lOffset);
      lOffset += 4;

      if(bTag == GCOV_TAG_ARC_COUNTER) {
        var bArcCounts =_parseArcCountsTag(aPos + lOffset);
        lOffset += bArcCounts.item1;
      } else {
        //Not out tag
        //TODO check if it is function tag?

        //Rewind to unread the tag read
        lOffset -= 4;

        break;
      }
    }

    //TODO

    return new Tuple2<int, dynamic>(lOffset, null);
  }

  Tuple2<int, dynamic> _parseArcCountsTag(int aPos) {
    int lOffset = 0;
    final int lLen = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    //TODO check if has length

    final int lNumCounts = lLen~/2;

    List<int> lCounts = new List<int>.filled(lNumCounts, 0);

    for(int cIdx = 0; cIdx < lNumCounts; cIdx++) {
      lCounts[cIdx] = helper.getInt64At(aPos + lOffset);
      lOffset += 8;
    }

    return new Tuple2<int, dynamic>(lOffset, null);
  }

  Tuple2<int, dynamic> _parseObjectTag(int aPos) {
    int lOffset = 0;
    final int lLen = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    //TODO check if has length

    final int lCSum = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    final int lNumCounts = (lLen-1)~/2;

    List<int> lCounts = new List<int>.filled(lNumCounts, 0);

    for(int cIdx = 0; cIdx < lNumCounts; cIdx++) {
      lCounts[cIdx] = helper.getInt64At(aPos + lOffset);
      lOffset += 8;
    }

    return new Tuple2<int, dynamic>(lOffset, null);
  }

  Tuple2<int, dynamic> _parseProgramTag(int aPos) {
    int lOffset = 0;
    final int lLen = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    //TODO check if has length

    final int lCSum = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    final int lNumCounts = (lLen-1)~/2;

    List<int> lCounts = new List<int>.filled(lNumCounts, 0);

    for(int cIdx = 0; cIdx < lNumCounts; cIdx++) {
      lCounts[cIdx] = helper.getInt64At(aPos + lOffset);
      lOffset += 8;
    }

    return new Tuple2<int, dynamic>(lOffset, null);
  }
}