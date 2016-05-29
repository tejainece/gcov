part of gcov.common;

class GcovVersion {
  bool _isNotDigit(int aVal) {
    return aVal < 0 || aVal > 9;
  }

  GcovVersion(this.num1, this.num2, this.num3, this.char4) {
    if(_isNotDigit(num1)) {
      throw new Exception("Num1 should be 0 to 9!");
    }

    if(_isNotDigit(num2)) {
      throw new Exception("Num2 should be 0 to 9!");
    }

    if(_isNotDigit(num3)) {
      throw new Exception("Num3 should be 0 to 9!");
    }
  }

  final int num1;

  final int num2;

  final int num3;

  final int char4;

  String toString() {
    return "$num1$num2$num3"+new String.fromCharCode(char4);
  }

  String getBigEndian() {
    return "$num1$num2$num3"+new String.fromCharCode(char4);
  }

  String getLittleEndian() {
    return new String.fromCharCode(char4)+"$num3$num2$num1";
  }

  String getByEndian(bool aBigEndian) {
    if(aBigEndian) {
      return getBigEndian();
    } else {
      return getLittleEndian();
    }
  }
}