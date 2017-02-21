/*
(c) Copyright 2013 - 2016 Xilinx, Inc. All rights reserved. 

This file contains confidential and proprietary information of Xilinx, Inc. and
is protected under U.S. and international copyright and other intellectual
property laws.

DISCLAIMER 
This disclaimer is not a license and does not grant any rights to the materials
distributed herewith. Except as otherwise provided in a valid license issued to
you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether
in contract or tort, including negligence, or under any other theory of
liability) for any loss or damage of any kind or nature related to, arising
under or in connection with these materials, including for any direct, or any
indirect, special, incidental, or consequential loss or damage (including loss
of data, profits, goodwill, or any type of loss or damage suffered as a result
of any action brought by a third party) even if such damage or loss was
reasonably foreseeable or Xilinx had been advised of the possibility of the
same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any
application requiring fail-safe performance, such as life-support or safety
devices or systems, Class III medical devices, nuclear facilities, applications
related to the deployment of airbags, or any other applications that could lead
to death, personal injury, or severe property or environmental damage
(individually and collectively, "Critical Applications"). Customer assumes the
sole risk and liability of any use of Xilinx products in Critical Applications,
subject only to applicable laws and regulations governing limitations on product
liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT
ALL TIMES. 
*/

#include <stdio.h>
#include <stdlib.h>

#include "mmult_accel.h"

/**
 *
 * Design principles to achieve II = 1
 * 1. Stream data into local RAM for inputs (multiple access required)
 * 2. Partition local RAMs into N/2 sub-arrays for fully parallel access (dual-port read)
 * 3. Pipeline the dot-product loop, to fully unroll it
 * 4. Separate multiply-accumulate in inner loop to force two FP operators
 *
 */
void mmult_accel(float A[N*N], float B[N*N], float C[N*N]) 
{
     float _A[N][N], _B[N][N];
#pragma HLS array_partition variable=_A block factor=16 dim=2
#pragma HLS array_partition variable=_B block factor=16 dim=1
     
     for(int i=0; i<N; i++) {
          for(int j=0; j<N; j++) {
#pragma HLS PIPELINE
               _A[i][j] = A[i * N + j];
               _B[i][j] = B[i * N + j];
          }
     }
     
     for (int i = 0; i < N; i++) {
          for (int j = 0; j < N; j++) {
#pragma HLS PIPELINE
               float result = 0;
               for (int k = 0; k < N; k++) {
                    float term = _A[i][k] * _B[k][j];
                    result += term;
               }
               C[i * N + j] = result;
          }
     }
}

#include "cf_stub.h"
void _p0_mmult_accel_1_noasync(float A[1024], float B[1024], float C[1024]);
void _p0_mmult_accel_1_noasync(float A[1024], float B[1024], float C[1024])
{
  switch_to_next_partition(0);
  int start_seq[1];
  start_seq[0] = 0;
  cf_request_handle_t _p0_swinst_mmult_accel_1_cmd;
  cf_send_i(&(_p0_swinst_mmult_accel_1.cmd_mmult_accel), start_seq, 1 * sizeof(int), &_p0_swinst_mmult_accel_1_cmd);
  cf_wait(_p0_swinst_mmult_accel_1_cmd);

  cf_send_i(&(_p0_swinst_mmult_accel_1.A), A, 4096, &_p0_request_0);
  cf_send_i(&(_p0_swinst_mmult_accel_1.B), B, 4096, &_p0_request_1);

  cf_receive_i(&(_p0_swinst_mmult_accel_1.C), C, 4096, &_p0_mmult_accel_1_noasync_num_C, &_p0_request_2);

  cf_wait(_p0_request_0);
  cf_wait(_p0_request_1);
  cf_wait(_p0_request_2);
}



