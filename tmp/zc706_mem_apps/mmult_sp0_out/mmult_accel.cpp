#include <string.h>
#include "mmult_accel.h"

int mmult_accel (float in_A[A_NROWS*A_NCOLS], float in_B[A_NCOLS*B_NCOLS], float *out_C)
{
#pragma HLS INTERFACE m_axi port=out_C depth=1024 offset=direct
#pragma HLS INTERFACE ap_ctrl_hs port=return 

  float c_buf[A_NCOLS*B_NCOLS];


  for (int row = 0; row < A_NROWS; row++) {
    for (int col = 0; col < B_NCOLS; col++) {
#pragma HLS PIPELINE II=1
      float result = 0.0;
      for (int k = 0; k < A_NCOLS; k++) {
        result += in_A[row*A_NCOLS+k] * in_B[k*B_NCOLS+col];
      }
      c_buf[row*A_NCOLS+col] = result;
    }
  }
  memcpy(out_C, c_buf, A_NROWS*A_NCOLS*sizeof(float));
  return 0;
}
