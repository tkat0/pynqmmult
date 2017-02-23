#ifndef MMULT_ACC_H_
#define MMULT_ACC_H_

#define A_NROWS 32
#define A_NCOLS 32
#define B_NCOLS 32
#define B_NROWS A_NCOLS


#pragma SDS data copy(in_A[0:A_NROWS*A_NCOLS])
#pragma SDS data copy(in_B[0:A_NROWS*A_NCOLS])
#pragma SDS data copy(out_C[0:A_NROWS*A_NCOLS])
#pragma SDS data sys_port(in_A:ACP, in_B:ACP, out_C:MIG)
int mmult_accel (float *in_A, float *in_B, float *out_C);

#endif /* MMULT_ACC_H_ */

