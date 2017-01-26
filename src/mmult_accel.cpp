#include <stdio.h>
#include <stdlib.h>

#include "mmult_accel.h"

void mmult_kernel(float in_A[A_NROWS][A_NCOLS],
                  float in_B[A_NCOLS][B_NCOLS],
                  float out_C[A_NROWS*B_NCOLS])
{
#pragma HLS INLINE self
#pragma HLS array_partition variable=in_A block factor=16 dim=2
#pragma HLS array_partition variable=in_B block factor=16 dim=1

  int index_a, index_b, index_d;

  for (index_a = 0; index_a < A_NROWS; index_a++) {
    for (index_b = 0; index_b < B_NCOLS; index_b++) {
#pragma HLS PIPELINE II=1
      float result = 0;
      for (index_d = 0; index_d < A_NCOLS; index_d++) {
        // multiply accumulate broken into individual operators
        // so that AutoESL can infer two FP operators
        float product_term = in_A[index_a][index_d] * in_B[index_d][index_b];
        result += product_term;
      }
      out_C[index_a * B_NCOLS + index_b] = result;
    }
  }
}

void mmult_accel (float in_A[A_NROWS*A_NCOLS],
                  float in_B[A_NCOLS*B_NCOLS],
                  float out_C[A_NROWS*B_NCOLS]) 
{
  int i, j;
  float a_buf[A_NROWS][A_NCOLS];
  float b_buf[A_NCOLS][B_NCOLS];

  // Transfer matrix A from multi-buffer into local RAM
  for(i=0; i<A_NROWS; i++) {
    for(j=0; j<A_NCOLS; j++) {
#pragma HLS PIPELINE II=1
      a_buf[i][j] = in_A[i * A_NCOLS + j];
    }
  }

  // Transfer matrix B from multi-buffer into local RAM
  for(i=0; i<A_NCOLS; i++) {
    for(j=0; j<B_NCOLS; j++) {
#pragma HLS PIPELINE II=1
      b_buf[i][j] = in_B[i * B_NCOLS + j];
    }
  }

  // Matrix multiply call
  mmult_kernel(a_buf, b_buf, out_C);
}

#include <stdio.h>
#include <stdlib.h>
#include "cf_stub.h"
void _p0_mmult_accel_0(float in_A[1024], float in_B[1024], float out_C[1024]);
void _p0_mmult_accel_0(float in_A[1024], float in_B[1024], float out_C[1024])
{
  switch_to_next_partition(0);
  int start_seq[3];
  start_seq[0] = 0x00000000;
  start_seq[1] = 0x00010000;
  start_seq[2] = 0x00020000;
  cf_request_handle_t _p0_swinst_mmult_accel_0_cmd;
  cf_send_i(&(_p0_swinst_mmult_accel_0.cmd_mmult_accel), start_seq, 3*sizeof(int), &_p0_swinst_mmult_accel_0_cmd);
  cf_wait(_p0_swinst_mmult_accel_0_cmd);

  cf_send_i(&(_p0_swinst_mmult_accel_0.in_A), in_A, 1024 * 4, &_p0_request_0);
  cf_send_i(&(_p0_swinst_mmult_accel_0.in_B), in_B, 1024 * 4, &_p0_request_1);

  cf_receive_i(&(_p0_swinst_mmult_accel_0.out_C), out_C, 1024 * 4, &_p0_mmult_accel_0_num_out_C, &_p0_request_2);

  cf_wait(_p0_request_0);
  cf_wait(_p0_request_1);
  cf_wait(_p0_request_2);
}


