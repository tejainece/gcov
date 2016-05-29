import 'package:test/test.dart';
import 'package:gcov/gcov/gcno/reader/reader.dart';
import 'package:gcov/gcov/common/common.dart';

void main() {
  group("", () {
    test("Invalid header length", () {
      StringBuffer lContMk = new StringBuffer();
      lContMk.write("oncg");

      var lHelper = new GcovReadHelperStr(false, lContMk.toString());
      var lGcno = new GcnoReader(false, lHelper);

      expect(() => lGcno.getFormat(),
          throwsA(const isInstanceOf<LengthException>()));
      expect(() => lGcno.getVersion(),
          throwsA(const isInstanceOf<LengthException>()));
      expect(() => lGcno.getChecksum(),
          throwsA(const isInstanceOf<LengthException>()));

      expect(lGcno.isFormatValid(), isFalse);
      expect(lGcno.isVersionValid(), isFalse);
      expect(() => lGcno.parse(),
          throwsA(const isInstanceOf<LengthException>()));
    });

    test("Invalid format", () {
      StringBuffer lContMk = new StringBuffer();
      lContMk.write("vocg*202");
      lContMk.writeCharCode(95);
      lContMk.writeCharCode(55);
      lContMk.writeCharCode(251);
      lContMk.writeCharCode(241);

      var lHelper = new GcovReadHelperStr(false, lContMk.toString());
      var lGcno = new GcnoReader(false, lHelper);

      expect(lGcno.getFormatStr(), equals("gcov"));
      expect(lGcno.getFormat(), equals(0x67636F76));
      expect(lGcno.getVersionStr(), equals("202*"));
      expect(lGcno.getVersion(), equals(0x3230322A));
      expect(lGcno.getChecksum(), equals(4059772767));

      expect(lGcno.isFormatValid(), isFalse);
      expect(lGcno.isVersionValid(), isFalse);
      expect(() => lGcno.parse(),
          throwsA(equals(invalidFormatErr)));
    });

    test("Unsupported version", () {
      StringBuffer lContMk = new StringBuffer();
      lContMk.write("oncg*202");
      lContMk.writeCharCode(95);
      lContMk.writeCharCode(55);
      lContMk.writeCharCode(251);
      lContMk.writeCharCode(241);

      var lHelper = new GcovReadHelperStr(false, lContMk.toString());
      var lGcno = new GcnoReader(false, lHelper);

      expect(lGcno.getFormatStr(), equals("gcno"));
      expect(lGcno.getFormat(), equals(GCNO_FORMAT));
      expect(lGcno.getVersionStr(), equals("202*"));
      expect(lGcno.getVersion(), equals(0x3230322A));
      expect(lGcno.getChecksum(), equals(4059772767));

      expect(lGcno.isFormatValid(), isTrue);
      expect(lGcno.isVersionValid(), isFalse);
      expect(() => lGcno.parse(),
          throwsA(equals(unsupportedVersionErr)));
    });

    test("No functions", () {
      StringBuffer lContMk = new StringBuffer();
      lContMk.write("oncg*305");
      lContMk.writeCharCode(95);
      lContMk.writeCharCode(55);
      lContMk.writeCharCode(251);
      lContMk.writeCharCode(241);

      var lHelper = new GcovReadHelperStr(false, lContMk.toString());
      var lGcno = new GcnoReader(false, lHelper);

      expect(lGcno.getFormatStr(), equals("gcno"));
      expect(lGcno.getFormat(), equals(GCNO_FORMAT));
      expect(lGcno.getVersionStr(), equals("503*"));
      expect(lGcno.getVersion(), equals(0x3530332A));
      expect(lGcno.getChecksum(), equals(4059772767));

      expect(lGcno.isFormatValid(), isTrue);
      expect(lGcno.isVersionValid(), isTrue);

      GcnoProgram lPrg = lGcno.parse();
      expect(lPrg.functions.length, equals(0));
    });

    test("No functions", () {
      var lHelper = new GcovReadHelperStr(false, "test/data/test1/test1.gcno");
      var lGcno = new GcnoReader(false, lHelper);

      expect(lGcno.getFormatStr(), equals("gcno"));
      expect(lGcno.getFormat(), equals(GCNO_FORMAT));
      expect(lGcno.getVersionStr(), equals("503*"));
      expect(lGcno.getVersion(), equals(0x3530332A));
      expect(lGcno.getChecksum(), equals(4059772767));

      expect(lGcno.isFormatValid(), isTrue);
      expect(lGcno.isVersionValid(), isTrue);

      GcnoProgram lPrg = lGcno.parse();
      expect(lPrg.functions.length, equals(0));
    });

    /*
    test("", () {
      GcnoTstBufferMaker lContMk = new GcnoTstBufferMaker(false);
      lContMk.writeFormat();
      lContMk.writeText("*305");
      lContMk.writeCharCodes([95, 55, 251, 241]);

      GcnoWriteFunction aFunc = new GcnoWriteFunction();
      lContMk.writeFunction(0x0000006C, 5);

      GcnoReader lGcno = new GcnoReader(lContMk.getString(), false);

      expect(lGcno.getFormat(), equals("oncg"));
      expect(lGcno.getVersion(), equals("*305"));
      expect(lGcno.getChecksum(), equals(4059772767));

      expect(lGcno.isFormatValid(), isTrue);
      expect(lGcno.isVersionValid(), isTrue);
      expect(lGcno.isValid(), isTrue);
      expect(lGcno.getNumFunctions(), 0);
    });
    */

    /*
    test("", () {
      GcnoTstBufferMaker lContMk = new GcnoTstBufferMaker(false);
      lContMk.writeFormat();
      lContMk.writeText("*305");
      lContMk.writeCharCodes([95, 55, 251, 241]);

      lContMk.writeFunction();

      GcnoReader lGcno = new GcnoReader(lContMk.getString(), false);

      expect(lGcno.getFormat(), equals("oncg"));
      expect(lGcno.getVersion(), equals("*305"));
      expect(lGcno.getChecksum(), equals(4059772767));

      expect(lGcno.isFormatValid(), isTrue);
      expect(lGcno.isVersionValid(), isTrue);
      expect(() => lGcno.isValid(), throwsA(const isInstanceOf<LengthException>()));
      expect(lGcno.getNumFunctions(), 0);
    });


    test("", () {
      GcnoTstBufferMaker lContMk = new GcnoTstBufferMaker(false);
      lContMk.writeFormat();
      lContMk.writeText("*305");
      lContMk.writeCharCodes([95, 55, 251, 241]);

      lContMk.writeFunction();

      GcnoReader lGcno = new GcnoReader(lContMk.getString(), false);

      expect(lGcno.getFormat(), equals("oncg"));
      expect(lGcno.getVersion(), equals("*305"));
      expect(lGcno.getChecksum(), equals(4059772767));

      expect(lGcno.isFormatValid(), isTrue);
      expect(lGcno.isVersionValid(), isTrue);
      expect(() => lGcno.isValid(), throwsA(const isInstanceOf<LengthException>()));
      expect(lGcno.getNumFunctions(), 0);
    });
    */
  });
}