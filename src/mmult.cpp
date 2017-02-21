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

#include <iostream>
#include <stdlib.h>
#include <stdint.h>

#include "sds_lib.h"
#include "mmult_accel.h"

#define NUM_TESTS 1024

class perf_counter
{
public:
     uint64_t tot, cnt, calls;
     perf_counter() : tot(0), cnt(0), calls(0) {};
     inline void reset() { tot = cnt = calls = 0; }
     inline void start() { cnt = sds_clock_counter(); calls++; };
     inline void stop() { tot += (sds_clock_counter() - cnt); };
     inline uint64_t avg_cpu_cycles() { return (tot / calls); };
};

static void init_arrays(float *A,  float *B, float *C_sw, float *C)
{
     for (int i = 0; i < N; i++) {
          for (int j = 0; j < N; j++) {
               A[i * N + j] = 1+i*N+j;
               B[i * N + j] = rand() % (N * N);
               C_sw[i * N + j] = 0.0;
               C[i * N + j] = 0.0;
          }
     }
}

void mmult_golden(float *A,  float *B, float *C)
{
     for (int row = 0; row < N; row++) {
          for (int col = 0; col < N; col++) {
               float result = 0.0;
               for (int k = 0; k < N; k++) {
                    result += A[row*N+k] * B[k*N+col];
               }
               C[row*N+col] = result;
          }
     }
}

static int result_check(float *C, float *C_sw)
{
     for (int i = 0; i < N * N; i++) {
          if (C_sw[i] != C[i]) {
               std::cout << "Mismatch: data index=" << i << "d=" << C_sw[i] 
                         << ", dout=" << C[i] << std::endl;
               return 1;
          }
     }
     return 0;
}

void _p0_mmult_accel_1_noasync(float A[1024], float B[1024], float C[1024]);
int mmult_test(float *A,  float *B, float *C_sw, float *C)
{
     std::cout << "Testing " << NUM_TESTS << " iterations of " << N << "x" << N 
               << " floating point mmult..." << std::endl;

     perf_counter hw_ctr, sw_ctr;
     
     for (int i = 0; i < NUM_TESTS; i++) 
     {
          init_arrays(A, B, C_sw, C);

          sw_ctr.start();
          mmult_golden(A, B, C_sw);
          sw_ctr.stop();

          hw_ctr.start();
          _p0_mmult_accel_1_noasync(A, B, C);
          hw_ctr.stop();

          if (result_check(C, C_sw))
               return 1;
     }
     uint64_t sw_cycles = sw_ctr.avg_cpu_cycles();
     uint64_t hw_cycles = hw_ctr.avg_cpu_cycles();
     double speedup = (double) sw_cycles / (double) hw_cycles;

     std::cout << "Average number of CPU cycles running mmult in software: "
               << sw_cycles << std::endl;
     std::cout << "Average number of CPU cycles running mmult in hardware: "
               << hw_cycles << std::endl;
     std::cout << "Speed up: " << speedup << std::endl;

     return 0;
}

/**
 * Design principles to achieve performance
 *
 * 1. sds_alloc to guarantee physically contiguous buffer allocation
 *    that enables the most efficient DMA configuration (axidma_simple)
 */
int main(int argc, char* argv[]){
     int test_passed = 0;
     float *A, *B, *C_sw, *C;

     A = (float *)sds_alloc(N * N * sizeof(float));
     B = (float *)sds_alloc(N * N * sizeof(float));
     C = (float *)sds_alloc(N * N * sizeof(float));
     C_sw = (float *)sds_alloc(N * N * sizeof(float));
     
     if (!A || !B || !C || !C_sw) {
          if (A) sds_free(A);
          if (B) sds_free(B);
          if (C) sds_free(C);
          if (C_sw) sds_free(C_sw);
          return 2;
     }
     
     test_passed = mmult_test(A, B, C_sw, C);
     
     std::cout << "TEST " << (test_passed ? "FAILED" : "PASSED") << std::endl;

     sds_free(A);
     sds_free(B);
     sds_free(C);
     sds_free(C_sw);
     
     return (test_passed ? -1 : 0);
}

