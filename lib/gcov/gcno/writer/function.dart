part of gcov.gcno.writer;

class GcnoWriteFunction {
  GcnoWriteFunction(this.identifer, this.funcName, this.fileName,
      this.chkSum, this.configChkSum, this.lineNum,
      this.blocks, this.lines) {}

  final int identifer;

  final int chkSum;

  final int configChkSum;

  final String funcName;

  final String fileName;

  final int lineNum;

  final List<GcnoWriteBlock> blocks;

  final GcnoWriteLine lines;

  int get writeLength {
    //identifier + checksum + configChecksum + lineNum
    int lRet = 4;

    lRet += gcovStringLen(funcName);
    lRet += gcovStringLen(fileName);

    if(blocks.length > 0) {
      //blockTag + blockCnt
      lRet += 2;

      //block flags
      lRet += blocks.length;

      for(GcnoWriteBlock aBlk in blocks) {
        lRet += aBlk.totalEdgeLength;
        lRet += aBlk.totalLineLen;
      }
    }

    return lRet;
  }
}