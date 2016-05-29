part of gcov.gcno.reader;

const int GCOV_ARCFLAG_ON_TREE = 0x1;
const int GCOV_ARCFLAG_FAKE = 0x2;
const int GCOV_ARCFLAG_FALLTHROUGH = 0x4;

class GcnoEdge {
  final int flags;

  GcnoEdge(this.src, this.dst, this.flags) {}

  final GcnoBlock src;

  final GcnoBlock dst;

  bool get isOnTree => (flags & GCOV_ARCFLAG_ON_TREE) != 0;

  bool get isFake => (flags & GCOV_ARCFLAG_FAKE) != 0;

  bool get isFallthrough => (flags & GCOV_ARCFLAG_FALLTHROUGH) != 0;

  String flagStr() {
    String lRet = "";

    if(isFallthrough) {
      lRet += "L";
    } else {
      lRet += "-";
    }

    if(isFake) {
      lRet += "F";
    } else {
      lRet += "-";
    }

    if(isOnTree) {
      lRet += "T";
    } else {
      lRet += "-";
    }

    return lRet;
  }
}

class GcnoBlock {
  GcnoBlock(this.index) {}

  final int index;

  List<GcnoEdge> get srcEdges => _srcEdges.toList(growable: false);

  List<GcnoEdge> get dstEdges => _dstEdges.toList(growable: false);

  Map<String, Set<int>> get lines {
    Map<String, Set<int>> lRet = new Map<String, Set<int>>();

    for(String cFile in _lines.keys) {
      lRet[cFile] = new Set<int>.from(_lines[cFile]);
    }

    return lRet;
  }

  List<GcnoEdge> _srcEdges = <GcnoEdge>[];

  List<GcnoEdge> _dstEdges = <GcnoEdge>[];

  Map<String, Set<int>> _lines = {};

  void addSrcEdge(GcnoEdge aSrc) {
    _srcEdges.add(aSrc);
  }

  void addDstEdge(GcnoEdge aDst) {
    _dstEdges.add(aDst);
  }

  void addLine(String aFile, int aLine) {
    Set<int> lLines = _lines[aFile];

    if(lLines is! Set<int>) {
      lLines = new Set<int>();

      _lines[aFile] = lLines;
    }

    lLines.add(aLine);
  }

  void print(PrintMaker aMk) {
    aMk.wrLn("Block${index}:");

    aMk.incIndent();

    aMk.wrLn("Lines:");

    aMk.incIndent();
    for(String cFile in _lines.keys) {
      aMk.wrLn(cFile);
      aMk.incIndent();
      aMk.wrLn(_lines[cFile].join(", "));
      aMk.decIndent();
    }
    aMk.decIndent();

    aMk.wrLn("to:");
    aMk.incIndent();
    StringBuffer lSrcEdges = _srcEdges.fold(new StringBuffer(), (StringBuffer aOld, GcnoEdge aEl) {
      if(aOld.length != 0) {
        aOld.write(", ");
      }
      aOld.write("Block${aEl.dst.index}[${aEl.flagStr()}]");
      return aOld;
    });
    aMk.wrLn(lSrcEdges.toString());
    aMk.decIndent();

    aMk.wrLn("from:");
    aMk.incIndent();
    StringBuffer lDstEdges = _dstEdges.fold(new StringBuffer(), (StringBuffer aOld, GcnoEdge aEl) {
      if(aOld.length != 0) {
        aOld.write(", ");
      }
      aOld.write("Block${aEl.src.index}[${aEl.flagStr()}]");
      return aOld;
    });
    aMk.wrLn(lDstEdges.toString());
    aMk.decIndent();

    aMk.decIndent();
  }
}

/// \brief Function information in GCNO file
class GcnoFunction {
  GcnoFunction(this.identifier, this.checksum,
      this.linenum, this.name,
      this.filename, this.blocks) {
  }

  final int identifier;

  final int checksum;

  final int linenum;

  final String name;

  final String filename;

  List<GcnoBlock> blocks;

  Map<String, Set<int>> getLines() {
    Map<String, Set<int>> lRet = new Map<String, Set<int>>();

    for(GcnoBlock cBlocks in blocks) {
      for(String cFile in cBlocks._lines.keys) {
        Set<int> bLines = lRet[cFile];

        if(bLines is! Set<int>) {
          bLines = new Set<int>();

          lRet[cFile] = bLines;
        }

        bLines.addAll(cBlocks._lines[cFile]);
      }
    }

    return lRet;
  }

  String toString() {
    PrintMaker lMk = new PrintMaker();

    lMk.wrLn("Function ${name}");

    lMk.incIndent();
    lMk.wrLn("Identifer: ${identifier}");
    lMk.wrLn("File: ${filename}");
    lMk.wrLn("Line: ${linenum}");
    lMk.wrLn("Blocks #: ${blocks.length}");

    Map<String, Set<int>> lLines = getLines();

    lMk.wrLn("Lines:");

    lMk.incIndent();
    for(String cFile in lLines.keys) {
      lMk.wrLn(cFile);
      lMk.incIndent();
      lMk.wrLn(lLines[cFile].join(", "));
      lMk.decIndent();
    }
    lMk.decIndent();

    lMk.wrLn("Blocks:");

    for(GcnoBlock cBlocks in blocks) {
      lMk.incIndent();
      cBlocks.print(lMk);
      lMk.decIndent();
    }

    lMk.decIndent();

    return lMk.toString();
  }
}

class GcnoProgram {
  GcnoProgram(this.functions);

  List<GcnoFunction> functions;

  String print({Set<String> aShowOnly, Set<String> aHide}) {
    String lRet = "";

    for(GcnoFunction cFunc in functions) {
      if(aShowOnly.length == 0 && aHide.length == 0) {
        lRet += cFunc.toString();
      } else if(aShowOnly.length == 0) {
        if(!aHide.contains(cFunc.name)) {
          lRet += cFunc.toString();
        }
      } else if(aHide.length == 0) {
        if(aShowOnly.contains(cFunc.name)) {
          lRet += cFunc.toString();
        }
      } else {
        if(!aHide.contains(cFunc.name) && aShowOnly.contains(cFunc.name)) {
          lRet += cFunc.toString();
        }
      }
    }

    return lRet;
  }
}

class PrintMaker {
  PrintMaker();

  StringBuffer _buffer = new StringBuffer();

  int _indent = 0;

  void incIndent() {
    _indent++;
  }

  void decIndent() {
    _indent--;
  }

  void wrLn(String aStr, [aIndent = 0]) {
    String lSpaces = ' ' * ((aIndent + _indent)*2);
    _buffer.writeln(lSpaces + aStr);
  }

  String toString() {
    return _buffer.toString();
  }
}