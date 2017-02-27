#include "cond.h"

uint32_t conditionalAdd(uint32_t aA, uint32_t aB) {
  uint32_t lRet = 0;
  if(aA > 10 && aA < 20) {
    lRet = aA + 2*aB;
  } else {
    lRet = aB;
  }

  return lRet;
}
