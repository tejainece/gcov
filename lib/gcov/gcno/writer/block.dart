part of gcov.gcno.writer;

class GcnoWriteBlock {
  GcnoWriteBlock(this.blk, this.flags, this.lines, this.edges) {}

  final int blk;

  final int flags;

  final GcnoWriteLine lines;

  final List<GcnoWriteEdge> edges;

  int get writeEdgeLength {
    return (edges.length * 2) + 1;
  }

  int get totalEdgeLength {
    if(edges.length == 0) {
      return 0;
    }

    //EdgeInfosLen + edgeTag + edgeCnt + block
    return writeEdgeLength + 3;
  }

  int get totalLineLen {
    return lines.totalLength;
  }
}