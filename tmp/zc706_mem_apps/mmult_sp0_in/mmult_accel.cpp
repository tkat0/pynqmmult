#include <string.h>
#include "mmult_accel.h"

int mmult_accel (float *in_A, float *in_B, float *out_C)
{
#pragma HLS INTERFACE m_axi port=in_A depth=1024 offset=direct bundle=mig
#pragma HLS INTERFACE m_axi port=in_B depth=1024 offset=direct bundle=mig
#pragma HLS INTERFACE m_axi port=out_C depth=1024 offset=direct bundle=afi
#pragma HLS INTERFACE ap_ctrl_hs port=return 

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
