library gcov.fixint;

import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';

int bigEndianToInt32(Uint8List aList, int aOffset) {
  int lRet = aList[aOffset];

  lRet <<= 8;
  lRet |= aList[aOffset + 1];

  lRet <<= 8;
  lRet |= aList[aOffset + 2];

  lRet <<= 8;
  lRet |= aList[aOffset + 3];

  return lRet;
}

Int32 littleEndianToInt32(Uint8List aList, int aOffset) {
  int lRet = aList[aOffset + 3];

  lRet <<= 8;
  lRet |= aList[aOffset + 2];

  lRet <<= 8;
  lRet |= aList[aOffset + 1];

  lRet <<= 8;
  lRet |= aList[aOffset + 0];

  return new Int32(lRet);
}

int bigEndianStrToInt32(String aStr, int aOffset) {
  int lRet = aStr.codeUnitAt(aOffset);

  lRet <<= 8;
  lRet |= aStr.codeUnitAt(aOffset + 1);

  lRet <<= 8;
  lRet |= aStr.codeUnitAt(aOffset + 2);

  lRet <<= 8;
  lRet |= aStr.codeUnitAt(aOffset + 3);

  return lRet;
}

int littleEndianStrToInt32(String aStr, int aOffset) {
  int lRet = aStr.codeUnitAt(aOffset + 3);

  lRet <<= 8;
  lRet |= aStr.codeUnitAt(aOffset + 2);

  lRet <<= 8;
  lRet |= aStr.codeUnitAt(aOffset + 1);

  lRet <<= 8;
  lRet |= aStr.codeUnitAt(aOffset + 0);

  return lRet;
}

int int32_get_byte0(int aIn) {
  return aIn & 0xFF;
}

int int32_get_byte1(int aIn) {
  return (aIn >> 8) & 0xFF;
}

int int32_get_byte2(int aIn) {
  return (aIn >> 16) & 0xFF;
}

int int32_get_byte3(int aIn) {
  return (aIn >> 24) & 0xFF;
}

Uint8List int32_to_list(int aIn) {
  Uint8List lList = new Uint8List(4);

  lList[0] = int32_get_byte0(aIn);
  lList[1] = int32_get_byte1(aIn);
  lList[2] = int32_get_byte2(aIn);
  lList[3] = int32_get_byte3(aIn);

  return lList;
}

Uint8List int32ToLittleEndian(int aIn) {
  return int32_to_list(aIn);
}

Uint8List int32ToBigEndian(int aIn) {
  return int32_to_list(aIn).reversed.toList(growable: false);
}

String int32ToString(int aIn) {
  return new String.fromCharCodes(int32_to_list(aIn).reversed.toList(growable: false));
}