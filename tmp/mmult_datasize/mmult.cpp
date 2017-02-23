#include <stdio.h>
#include <stdlib.h>

#include "mmult_accel.h"

#define NUM_TESTS 1024

#include "sds_lib.h"
#define TIME_STAMP_INIT  unsigned long long clock_start, clock_end;  clock_start = sds_clock_counter();  
#define TIME_STAMP_SW  { clock_end = sds_clock_counter(); printf("Average number of processor cycles for golden version: %llu \n", (clock_end-clock_start)/NUM_TESTS); clock_start = sds_clock_counter();  }
#define TIME_STAMP_ACCEL  { clock_end = sds_clock_counter(); printf("Average number of processor cycles for hardware version: %llu \n", (clock_end-clock_start)/NUM_TESTS); }

static void mmult_init(int dim1, float *tin1Buf,  float *tin2Buf, float *toutBufSw, float *toutBufHw)
{
  int i, j;
  
  for (i = 0; i < dim1; i++) {
    for (j = 0; j < dim1; j++) {
      tin1Buf[i * dim1 + j] = 1+i*dim1+j;
    }
  }
  for (i = 0; i < dim1; i++) {  
    for (j = 0; j < dim1; j++) {
      tin2Buf[i * dim1 + j] = rand() % (dim1 * dim1);
    }
  }
  for (i = 0; i < dim1; i++) {
    for (j = 0; j < dim1; j++) {
      toutBufSw[i * dim1 + j] = 0.0;
      toutBufHw[i * dim1 + j] = 0.0;
    }
  }
}

void mmult_golden(float *in_arr,  float *in_arr2, float *out_arr, int dim1)
{
  for (int row = 0; row < dim1; row++) {
    for (int col = 0; col < dim1; col++) {
      float result = 0.0;
      for (int k = 0; k < dim1; k++) {
        result += in_arr[row*dim1+k] * in_arr2[k*dim1+col];
      }
      out_arr[row*dim1+col] = result;
    }
  }
}

static int mmult_result_check(int dim1, float *toutBufSw, float *toutBufHw)
{
  int i;
  
  for (i = 0; i < dim1 * dim1; i++) {
    if (toutBufSw[i] != toutBufHw[i]) {
      printf("Mismatch: data index=%d d=%f, dout=%f\n", i, toutBufSw[i], toutBufHw[i]);
      return 0;
    }
  }
  return 1;
}

int mmult_test(int dim1, float *tin1Buf,  float *tin2Buf, float *toutBufSw, float *toutBufHw)
{
  int i;
  
  printf("Testing mmult ...\n");
  
  mmult_init(dim1, tin1Buf, tin2Buf, toutBufSw, toutBufHw);

  TIME_STAMP_INIT

  for (i = 0; i < NUM_TESTS; i++) {
    mmult_golden(tin1Buf, tin2Buf, toutBufSw, dim1);
  }

  TIME_STAMP_SW

  for (i = 0; i < NUM_TESTS; i++)
    mmult_accel(tin1Buf, tin2Buf, toutBufHw, dim1);

  TIME_STAMP_ACCEL

  return mmult_result_check(dim1, toutBufSw, toutBufHw);
}


int main(int argc, char* argv[]){
  int test_passed = 0;
  float *tin1Buf, *tin2Buf, *toutBufSw, *toutBufHw;
  
  tin1Buf = (float *)sds_alloc(A_NROWS * A_NCOLS * sizeof(float));
  tin2Buf = (float *)sds_alloc(A_NCOLS * B_NCOLS * sizeof(float));
  toutBufHw = (float *)sds_alloc(A_NROWS * B_NCOLS * sizeof(float));
  toutBufSw = (float *)sds_alloc(A_NROWS * B_NCOLS * sizeof(float));

  if (!tin1Buf || !tin2Buf || !toutBufHw || !toutBufSw) {
    if (tin1Buf) sds_free(tin1Buf);
    if (tin2Buf) sds_free(tin2Buf);
    if (toutBufHw) sds_free(toutBufHw);
    if (toutBufSw) sds_free(toutBufSw);
    return 2;
  }

  printf("Testing with A_NROWS = A_NCOLS = B_NCOLS = B_NROWS = %d\n", 32);
  test_passed = mmult_test(32, tin1Buf, tin2Buf, toutBufSw, toutBufHw);
  printf("TEST %s\n", test_passed ? "PASSED" : "FAILED");

  test_passed = 0;
  
  printf("Testing with A_NROWS = A_NCOLS = B_NCOLS = B_NROWS = %d\n", 16);
  test_passed = mmult_test(16, tin1Buf, tin2Buf, toutBufSw, toutBufHw);
  printf("TEST %s\n", test_passed ? "PASSED" : "FAILED");
  
  sds_free(tin1Buf);
  sds_free(tin2Buf);
  sds_free(toutBufHw);
  sds_free(toutBufSw);
  
  
  return (test_passed ? 0 : -1);
}
