part of gcov.gcno.writer;

class GcnoWriteEdge {
  GcnoWriteEdge(this.srcBlk, this.dstBlk, this.flags) {}

  final int srcBlk;

  final int dstBlk;

  final int flags;

  int get writeEdgeLength => 2;
}

class GcnoWriteLine {
  GcnoWriteLine(this.block,
      this.filename, this.lineNums,
      this.flag1, this.flag2) {
  }

  final int block;

  final int flag1;

  final int flag2;

  final String filename;

  final List<int> lineNums;

  int get writeLength {
    //flag1, flag2, block
    int lRet = 3;

    if(lineNums.length > 0) {
      //line nums
      lRet += lineNums.length;
      //filename
      lRet += gcovStringLen(filename);
      //Null terminator
      lRet += 1;
    }

    return lRet;
  }

  int get totalLength {
    if(lineNums.length == 0) {
      return 0;
    }

    //writeLength + lineTag + length
    return writeLength + 2;
  }
}