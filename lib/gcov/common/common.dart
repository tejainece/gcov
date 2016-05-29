library gcov.common;

import 'dart:typed_data';
import 'package:gcov/utils/fixint.dart';
import 'package:tuple/tuple.dart';

part 'version.dart';
part 'writer.dart';
part 'reader.dart';

/// Character code for '0'
const int CHAR_ZERO = 0x30;

/// Length of the GCNO header
///
/// Includes Format{4} + Version{4} + Checksum{4}
const int GCNO_HEADER_LEN = 12;

/// Format string for GCNO file
const int GCNO_FORMAT = 0x67636E6F;

/// Tag to mark start of function
const int GCOV_FUNCTION_TAG = 0x01000000;

/// Tag to mark start of block
const int GCOV_BLOCK_TAG = 0x01410000;

/// Tag to mark start of edge
const int GCOV_EDGE_TAG = 0x01430000;

/// Tag to mark start of line
const int GCOV_LINE_TAG = 0x01450000;

/// List of valid GCNO versions this library can understand
const List<String> GCOV_VERSIONS_VALID = const <String>["503*"];

/// Returns the length of GCOV string
///
/// @param The string whose length should be found
/// @returns Length of GCOV string
int gcovStringLen(String aStr) {
  return (aStr.length/4).ceil() + 1;
}