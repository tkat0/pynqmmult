#ifndef _SDS_PORTINFO_H
#define _SDS_PORTINFO_H
/* File: C:/Users/tkato/workspace_2016.3/pynq-mmult/Debug/_sds/p0/.cf_work/portinfo.h */
#ifdef __cplusplus
extern "C" {
#endif

struct _p0_swblk_mmult_accel {
  cf_port_send_t cmd_mmult_accel;
  cf_port_send_t A;
  cf_port_send_t B;
  cf_port_receive_t C;
};

extern struct _p0_swblk_mmult_accel _p0_swinst_mmult_accel_1;
void _p0_cf_framework_open(int);
void _p0_cf_framework_close(int);

#ifdef __cplusplus
};
#endif
#ifdef __cplusplus
extern "C" {
#endif
void switch_to_next_partition(int);
void init_first_partition();
void close_last_partition();
#ifdef __cplusplus
};
#endif /* extern "C" */
#endif /* _SDS_PORTINFO_H_ */
