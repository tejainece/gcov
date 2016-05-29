/// GCNO writer framework
library gcov.gcno.writer;

import 'package:gcov/gcov/gcno/common/common.dart';
import 'package:gcov/gcov/common/common.dart';

part 'function.dart';
part 'block.dart';
part 'line.dart';

class GcnoWriterDefault extends GcovWriterWithBuffer implements GcnoWriter {
  final bool bigEndian;

  final GcovVersion version;

  final int stamp;

  GcnoWriterDefault(this.bigEndian, this.version, this.stamp, List<GcnoWriteFunction> aFuncs) {
    _write(aFuncs);
  }

  StringBuffer _buffer = new StringBuffer();

  StringBuffer get buffer => _buffer;

  void _write(List<GcnoWriteFunction> aFuncs) {
    writeInt32(GCNO_FORMAT);
    writeVersion(version);
    writeInt32(stamp);

    for(GcnoWriteFunction cFunc in aFuncs) {
      writeFunction(cFunc);
    }
  }

  void writeFunction(GcnoWriteFunction aFunc) {
    writeInt32(GCOV_FUNCTION_TAG);

    writeInt32(aFunc.writeLength);

    writeInt32(aFunc.identifer);

    writeInt32(aFunc.chkSum);

    writeInt32(aFunc.configChkSum);

    writeString(aFunc.funcName);

    writeString(aFunc.fileName);

    writeInt32(aFunc.lineNum);

    _writeBlocks(aFunc.blocks);

    for(GcnoWriteBlock cBlk in aFunc.blocks) {
      _writeEdge(cBlk);
    }

    for(GcnoWriteBlock cBlk in aFunc.blocks) {
      _writeLine(cBlk.lines);
    }
  }

  void _writeBlocks(List<GcnoWriteBlock> aBlocks) {
    writeInt32(GCOV_BLOCK_TAG);

    writeInt32(aBlocks.length);

    for(GcnoWriteBlock cBlk in aBlocks) {
      writeInt32(cBlk.flags);
    }
  }

  void _writeLine(GcnoWriteLine aLineInfo) {
    if(aLineInfo.lineNums.length == 0) {
      return;
    }

    writeInt32(GCOV_LINE_TAG);

    writeInt32(aLineInfo.writeLength);

    writeInt32(aLineInfo.block);

    writeInt32(aLineInfo.flag1);

    if(aLineInfo.lineNums.length != 0) {
      writeString(aLineInfo.filename);

      for(int cLineNum in aLineInfo.lineNums) {
        writeInt32(cLineNum);
      }

      //Termination
      writeInt32(0);
    }

    writeInt32(aLineInfo.flag2);
  }

  void _writeEdge(GcnoWriteBlock aBlk) {
    if(aBlk.edges.length == 0) {
      return;
    }

    writeInt32(GCOV_EDGE_TAG);

    writeInt32(aBlk.writeEdgeLength);

    writeInt32(aBlk.blk);

    for(GcnoWriteEdge cEdge in aBlk.edges) {
      //Write destination block
      writeInt32(cEdge.dstBlk);
      //Write flags
      writeInt32(cEdge.flags);
    }
  }

  String getString() {
    return _buffer.toString();
  }
}