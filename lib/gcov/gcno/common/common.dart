/// This file has all the constants of GCNO file

library gcov.gcno.common;

/// Interface for GCNO writer
abstract class GcnoWriter {
  /// Endianess of the writer
  bool get bigEndian;
}