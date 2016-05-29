part of gcov.gcno.reader;

class GcnoBlock {
  GcnoBlock() {
    //TODO
  }

  List<GcnoEdge> _srcEdges = <GcnoEdge>[];

  List<GcnoEdge> _dstEdges = <GcnoEdge>[];

  List<int> _lines = <int>[];

  void addSrcEdge(GcnoEdge aSrc) {
    _srcEdges.add(aSrc);
  }

  void addDstEdge(GcnoEdge aDst) {
    _dstEdges.add(aDst);
  }

  void addLine(int aLine) {
    _lines.add(aLine);
  }
}

class GcnoEdge {
  GcnoEdge(this.src, this.dst) {}

  final GcnoBlock src;

  final GcnoBlock dst;
}

/// \brief Function information in GCNO file
class GcnoFunction {
  GcnoFunction(this.identifier, this.checksum,
      this.linenum, this.name,
      this.filename, this.blocks, this.edges) {
  }

  final int identifier;

  final int checksum;

  final int linenum;

  final String name;

  final String filename;

  List<GcnoBlock> blocks;

  List<GcnoEdge> edges;
}

class GcnoProgram {
  GcnoProgram(this.functions);

  List<GcnoFunction> functions;
}