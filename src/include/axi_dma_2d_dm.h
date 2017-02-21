/*
© Copyright 2013 - 2016 Xilinx, Inc. All rights reserved. 

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

#ifndef AXI_DMA_2D_DM_H
#define AXI_DMA_2D_DM_H

#include "cf_lib.h"

#ifdef __cplusplus
extern "C" {
#endif
struct axi_dma_2d_bd_struct {
	unsigned int next_desc_ptr; // 31:6 -> ptr, 5:0 -> reserved
	unsigned int reserved1;
	unsigned int buffer_addr;
	unsigned int reserved2;
	unsigned int attr_bytes; // 31:28 -> ARUSER, 27:24 -> ARCACHE; TX ONLY -> 19:16 -> TUSER, 12:8 -> TID, 4:0 -> TDEST
	unsigned int vsize_stride; // 31:19->Vsize, 15:0 -> stride
	unsigned int ctrl_hsize; // 27 -> SOP, 26 -> EOP, 15:0 -> Hsize
	unsigned int status; // 31 -> Cmp, 30 -> DE, 29 -> SE, 28-> IE; RX ONLY -> 27->SOP, 26->EOP, 19:16 -> TUSER, 12:8->TID, 4:0->TDEST
};

struct axi_dma_2d_info_struct {
	char* name;
	int device_id;
	uint64_t phys_base_addr;
	int addr_range;
	int uio_fd;
	void* virt_base_addr;
	int dir; // either DMA_TO_DEV or DMA_FROM_DEV 
	int needs_cache_flush_invalidate;
	struct axi_dma_2d_bd_struct *current_bd;
	struct axi_dma_2d_bd_struct *desc_chain;
	int first_op;
	int dm_id;
};
typedef struct axi_dma_2d_info_struct axi_dma_2d_info_t;

int axi_dma_2d_open (axi_dma_2d_info_t *info);
int axi_dma_2d_close (axi_dma_2d_info_t *info);

int axi_dma_2d_send_ref_i (cf_port_send_t *port,
	const void *buf,
	unsigned int len,
	cf_request_handle_t *request);

int axi_dma_2d_send_i (cf_port_send_t *port,
	const void *buf,
	unsigned int len,
	cf_request_handle_t *request);

int axi_dma_2d_send_iov_i(cf_port_send_t *port,
	const cf_iovec_t *iov,
	unsigned int iovcnt,
	cf_request_handle_t *request);

int axi_dma_2d_send2d_i (cf_port_send_t *port,
	const void *buf,
	unsigned int xsize,
	unsigned int numlines,
	unsigned int xstride,
	cf_request_handle_t *request);

int axi_dma_2d_recv_i (cf_port_receive_t *port,
	void *buf,
	unsigned int len,
	unsigned int *num_recd,
	cf_request_handle_t *request);

int axi_dma_2d_recv_iov_i(cf_port_receive_t *port,
	cf_iovec_t *iov,
	unsigned int iovcnt,
	unsigned int *bytes_received,
	cf_request_handle_t *request);

int axi_dma_2d_recv2d_i (cf_port_receive_t *port,
	void *buf,
	unsigned int xsize,
	unsigned int numlines,
	unsigned int xstride,
	cf_request_handle_t *request);

int axi_dma_2d_recv_ref_i (cf_port_receive_t *port,
	void **buf,
	unsigned int *len,
	cf_request_handle_t *request);

#ifdef __cplusplus
};
#endif

#endif


// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
