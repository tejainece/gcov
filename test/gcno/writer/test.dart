import 'package:test/test.dart';
import 'package:gcov/gcov/gcno/writer/writer.dart';
import 'package:gcov/gcov/common/common.dart';

void testEmptyCompUnit() {
  final lStamp = 0xF1FB375F;
  final lVer = new GcovVersion(5, 0, 3, 42);
  var lWriter = new GcnoWriterDefault(false, lVer, lStamp, []);

  String lStr = lWriter.getString();

  final lExpected = [
    0x6f, 0x6e, 0x63, 0x67,
    0x2a, 0x33, 0x30, 0x35,
    0x5f, 0x37, 0xfb, 0xf1
  ];

  expect(lStr.codeUnits, equals(lExpected));
}

void register() {
  group("", () {
    test("Empty compilation unit", () => testEmptyCompUnit());
  });
  //TODO
}

void main() {
  register();
}