#include <string.h>
#include "mmult_accel.h"

int mmult_accel (float *in_A, float *in_B, float *out_C)
{
  float a_buf[A_NROWS*A_NCOLS];
  float b_buf[A_NCOLS*B_NCOLS];
  float c_buf[A_NCOLS*B_NCOLS];

  memcpy(a_buf, in_A, A_NROWS*A_NCOLS*sizeof(float));
  memcpy(b_buf, in_B, A_NROWS*A_NCOLS*sizeof(float));

  for (int row = 0; row < A_NROWS; row++) {
    for (int col = 0; col < B_NCOLS; col++) {
#pragma HLS PIPELINE II=1
      float result = 0.0;
      for (int k = 0; k < A_NCOLS; k++) {
        result += a_buf[row*A_NCOLS+k] * b_buf[k*B_NCOLS+col];
      }
      c_buf[row*A_NCOLS+col] = result;
    }
  }
  memcpy(out_C, c_buf, A_NROWS*A_NCOLS*sizeof(float));
  return 0;
}
