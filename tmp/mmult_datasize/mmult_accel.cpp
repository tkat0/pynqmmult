#include <stdio.h>
#include <stdlib.h>

#include "mmult_accel.h"

void mmult_kernel(float in_A[A_NROWS][A_NCOLS],
                  float in_B[A_NCOLS][B_NCOLS],
                  float out_C[A_NROWS*B_NCOLS],
                  int dim1)
{
#pragma HLS INLINE self
#pragma HLS array_partition variable=in_A block factor=16 dim=2
#pragma HLS array_partition variable=in_B block factor=16 dim=1

  int index_a, index_b, index_d;

  for (index_a = 0; index_a < dim1; index_a++) {
    for (index_b = 0; index_b < dim1; index_b++) {
      float result = 0;
      for (index_d = 0; index_d < dim1; index_d++) {
#pragma HLS PIPELINE II=1
#pragma HLS loop_tripcount min=16 max=32
        // multiply accumulate broken into individual operators
        // so that AutoESL can infer two FP operators
        float product_term = in_A[index_a][index_d] * in_B[index_d][index_b];
        result += product_term;
      }
      out_C[index_a * dim1 + index_b] = result;
    }
  }
}

void mmult_accel (float in_A[A_NROWS*A_NCOLS],
                  float in_B[A_NCOLS*B_NCOLS],
                  float out_C[A_NROWS*B_NCOLS],
                  int dim1) 
{
  int i, j;
  float a_buf[A_NROWS][A_NCOLS];
  float b_buf[A_NCOLS][B_NCOLS];

  // Transfer matrix A from multi-buffer into local RAM
  for(i=0; i<dim1; i++) {
    for(j=0; j<dim1; j++) {
#pragma HLS PIPELINE II=1
      a_buf[i][j] = in_A[i * dim1 + j];
    }
  }

  // Transfer matrix B from multi-buffer into local RAM
  for(i=0; i<dim1; i++) {
    for(j=0; j<dim1; j++) {
#pragma HLS PIPELINE II=1
      b_buf[i][j] = in_B[i * dim1 + j];
    }
  }

  // Matrix multiply call
  mmult_kernel(a_buf, b_buf, out_C, dim1);
}
