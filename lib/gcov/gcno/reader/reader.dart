library gcov.gcno.reader;

import 'package:tuple/tuple.dart';
import 'package:gcov/gcov/common/common.dart';

part 'function.dart';
part 'exceptions.dart';

/// Reads GCNO files given as string
class GcnoReader extends GcovReader {
  final bool bigEndian;

  final GcovReadHelper helper;

  GcnoReader(this.bigEndian, this.helper);

  bool hasFunctionTagAt(int aPos) {
    if (!helper.hasEnoughLen(aPos + 4)) {
      return false;
    }

    return helper.getInt32At(aPos) == GCOV_FUNCTION_TAG;
  }

  bool hasBlockTagAt(int aPos) {
    if (!helper.hasEnoughLen(aPos + 4)) {
      return false;
    }

    return helper.getInt32At(aPos) == GCOV_BLOCK_TAG;
  }

  bool hasEdgeTagAt(int aPos) {
    if (!helper.hasEnoughLen(aPos + 4)) {
      return false;
    }

    return helper.getInt32At(aPos) == GCOV_EDGE_TAG;
  }

  bool hasLineTagAt(int aPos) {
    if (!helper.hasEnoughLen(aPos + 4)) {
      return false;
    }

    return helper.getInt32At(aPos) == GCOV_LINE_TAG;
  }

  bool isFormatValid() {
    if (!hasHeader()) {
      return false;
    }

    if (getFormat() != GCNO_FORMAT) {
      return false;
    }

    return true;
  }

  GcnoProgram parse() {
    if(!hasHeader()) {
      throw new LengthException(12, helper.contentLen);
    }

    if (!isFormatValid()) {
      throw invalidFormatErr;
    }

    if (!isVersionValid()) {
      throw unsupportedVersionErr;
    }

    List<GcnoFunction> lFuncs = <GcnoFunction>[];

    int bPos = GCNO_HEADER_LEN;
    while (true) {
      Tuple2<int, GcnoFunction> bNewFunc = _getFunctionAt(bPos);

      if (bNewFunc.item2 == null) {
        break;
      }

      lFuncs.add(bNewFunc.item2);

      bPos += bNewFunc.item1;
    }

    GcnoProgram lProg = new GcnoProgram(lFuncs);

    return lProg;
  }

  Tuple2<int, GcnoFunction> _getFunctionAt(int aPos) {
    int lOffset = 0;
    if (!hasFunctionTagAt(aPos + lOffset)) {
      return new Tuple2<int, GcnoFunction>(0, null);
    }
    lOffset += 4;

    int lLen = helper.getInt32At(aPos + lOffset);
    if (!helper.hasEnoughLen(aPos + lLen)) {
      throw new LengthException(aPos + lLen, helper.contentLen);
    }
    lOffset += 4;

    int lIdentifier = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    int lCSum = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    /* TODO
    int lCfgCSum = _getInt32At(aPos);

    if(lCfgCSum != getChecksum()) {
      throw new FuncChkSumException._create();
    }
    */
    lOffset += 4;

    Tuple2<int, String> lFuncName = helper.getGCovString(aPos + lOffset);
    lOffset += lFuncName.item1;

    Tuple2<int, String> lFileName = helper.getGCovString(aPos + lOffset);
    lOffset += lFileName.item1;

    int lLineNum = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    Tuple2<int, List<GcnoBlock>> lBlocks = _getBlocksAt(aPos + lOffset);
    lOffset += lBlocks.item1;

    Tuple2<int, List<GcnoEdge>> lEdges =
        _getEdgeAt(aPos + lOffset, lBlocks.item2);
    lOffset += lEdges.item1;

    while (hasLineTagAt(aPos + lOffset)) {
      lOffset += 4;

      lOffset += _getLineAt(aPos + lOffset, lBlocks.item2);
    }

    GcnoFunction bNewFunc = new GcnoFunction(lIdentifier, lCSum, lLineNum,
        lFuncName.item2, lFileName.item2, lBlocks.item2);

    return new Tuple2<int, GcnoFunction>(lOffset, bNewFunc);
  }

  Tuple2<int, List<GcnoBlock>> _getBlocksAt(int aPos) {
    int lOffset = 0;
    if (!hasBlockTagAt(aPos + lOffset)) {
      return null;
    }
    lOffset += 4;

    int lBlockCnt = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    List<GcnoBlock> lBlocks = <GcnoBlock>[];
    for (int cIdx = 0; cIdx < lBlockCnt; cIdx++) {
      lBlocks.add(new GcnoBlock(cIdx));

      //TODO block flags
      lOffset += 4;
    }

    return new Tuple2<int, List<GcnoBlock>>(lOffset, lBlocks);
  }

  Tuple2<int, List<GcnoEdge>> _getEdgeAt(int aPos, List<GcnoBlock> aBlocks) {
    int lOffset = 0;
    List<GcnoEdge> lRet = <GcnoEdge>[];

    while (hasEdgeTagAt(aPos + lOffset)) {
      lOffset += 4;

      int lEdgeCnt = helper.getInt32At(aPos + lOffset);
      lOffset += 4;

      lEdgeCnt = (lEdgeCnt - 1) ~/ 2;

      int lBlock = helper.getInt32At(aPos + lOffset);
      lOffset += 4;

      //Check if block is valid
      if (lBlock >= aBlocks.length) {
        throw new InvalidBlockException._create();
      }

      for (int cIdx = 0; cIdx < lEdgeCnt; cIdx++) {
        int bDst = helper.getInt32At(aPos + lOffset);
        //Check if block is valid
        if (bDst >= aBlocks.length) {
          throw new InvalidBlockException._create();
        }
        lOffset += 4;

        int bFlag = helper.getInt32At(aPos + lOffset);
        lOffset += 4;

        GcnoEdge bEdge = new GcnoEdge(aBlocks[lBlock], aBlocks[bDst], bFlag);
        lRet.add(bEdge);

        aBlocks[lBlock].addSrcEdge(bEdge);
        aBlocks[bDst].addDstEdge(bEdge);
      }
    }

    return new Tuple2<int, List<GcnoEdge>>(lOffset, lRet);
  }

  int _getLineAt(int aPos, List<GcnoBlock> aBlocks) {
    int lOffset = 0;

    int lLen = helper.getInt32At(aPos + lOffset) * 4;
    lOffset += 4;

    int lBlock = helper.getInt32At(aPos + lOffset);
    lOffset += 4;

    //Check if block is valid
    if (lBlock >= aBlocks.length) {
      throw new InvalidBlockException._create();
    }

    //TODO some flags?
    lOffset += 4;

    if ((lOffset-4) < (lLen - 8)) {
      Tuple2<int, String> lFileName = helper.getGCovString(aPos + lOffset);
      lOffset += lFileName.item1;

      while ((lOffset-4) < (lLen - 8)) {
        int bLine = helper.getInt32At(aPos + lOffset);
        lOffset += 4;

        if (bLine == 0) {
          continue;
        }

        aBlocks[lBlock].addLine(lFileName.item2, bLine);
      }

      //Terminating null character
      lOffset += 4;
    }

    //TODO some flags?
    lOffset += 4;

    return lOffset;
  }
}
