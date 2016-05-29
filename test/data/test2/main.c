#include<stdio.h>

int add(int a, int b) {
  return a + b;
}

int sub(int a, int b) {
  return a - b;
}

int main(int argc, char const *argv[]) {
  add(5, 5);
  sub(5, 5);

  return 0;
}
