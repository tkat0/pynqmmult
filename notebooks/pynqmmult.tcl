
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design -bdsource SDSoC $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports

  # Create instance: acp_axcache_0xE, and set properties
  set acp_axcache_0xE [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 acp_axcache_0xE ]
  set_property -dict [ list \
CONFIG.CONST_VAL {14} \
CONFIG.CONST_WIDTH {4} \
 ] $acp_axcache_0xE

  # Create instance: axi_ic_ps7_M_AXI_GP0, and set properties
  set axi_ic_ps7_M_AXI_GP0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ps7_M_AXI_GP0 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.M02_HAS_REGSLICE {1} \
CONFIG.M03_HAS_REGSLICE {1} \
CONFIG.NUM_MI {4} \
CONFIG.NUM_SI {1} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.STRATEGY {2} \
 ] $axi_ic_ps7_M_AXI_GP0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.S00_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
 ] $axi_ic_ps7_M_AXI_GP0

  # Create instance: axi_ic_ps7_S_AXI_ACP, and set properties
  set axi_ic_ps7_S_AXI_ACP [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ps7_S_AXI_ACP ]
  set_property -dict [ list \
CONFIG.M00_HAS_DATA_FIFO {2} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {3} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.STRATEGY {2} \
 ] $axi_ic_ps7_S_AXI_ACP

  # Create instance: dm_0, and set properties
  set dm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dm_0 ]
  set_property -dict [ list \
CONFIG.c_dlytmr_resolution {1250} \
CONFIG.c_include_mm2s {1} \
CONFIG.c_include_mm2s_dre {1} \
CONFIG.c_include_mm2s_sf {1} \
CONFIG.c_include_s2mm {0} \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {64} \
CONFIG.c_mm2s_burst_size {64} \
CONFIG.c_sg_length_width {23} \
 ] $dm_0

  # Create instance: dm_1, and set properties
  set dm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dm_1 ]
  set_property -dict [ list \
CONFIG.c_dlytmr_resolution {1250} \
CONFIG.c_include_mm2s {1} \
CONFIG.c_include_mm2s_dre {1} \
CONFIG.c_include_mm2s_sf {1} \
CONFIG.c_include_s2mm {0} \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {64} \
CONFIG.c_mm2s_burst_size {64} \
CONFIG.c_sg_length_width {23} \
 ] $dm_1

  # Create instance: dm_2, and set properties
  set dm_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dm_2 ]
  set_property -dict [ list \
CONFIG.c_dlytmr_resolution {1250} \
CONFIG.c_include_mm2s {0} \
CONFIG.c_include_s2mm {1} \
CONFIG.c_include_s2mm_dre {1} \
CONFIG.c_include_s2mm_sf {1} \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {64} \
CONFIG.c_s2mm_burst_size {64} \
CONFIG.c_sg_length_width {23} \
 ] $dm_2

  # Create instance: mmult_accel_1, and set properties
  set mmult_accel_1 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mmult_accel:1.0 mmult_accel_1 ]

  # Create instance: mmult_accel_1_if, and set properties
  set mmult_accel_1_if [ create_bd_cell -type ip -vlnv xilinx.com:ip:adapter_v3_0:1.0 mmult_accel_1_if ]
  set_property -dict [ list \
CONFIG.C_INPUT_FIFO_0_DEPTH {1024} \
CONFIG.C_INPUT_FIFO_0_DMWIDTH {64} \
CONFIG.C_INPUT_FIFO_0_WIDTH {32} \
CONFIG.C_INPUT_FIFO_1_DEPTH {1024} \
CONFIG.C_INPUT_FIFO_1_DMWIDTH {64} \
CONFIG.C_INPUT_FIFO_1_WIDTH {32} \
CONFIG.C_NUM_INPUT_BRAMs {0} \
CONFIG.C_NUM_INPUT_FIFOs {2} \
CONFIG.C_NUM_OUTPUT_BRAMs {0} \
CONFIG.C_NUM_OUTPUT_FIFOs {1} \
CONFIG.C_OUTPUT_FIFO_0_DEPTH {1024} \
CONFIG.C_OUTPUT_FIFO_0_DMWIDTH {64} \
CONFIG.C_OUTPUT_FIFO_0_WIDTH {32} \
 ] $mmult_accel_1_if

  # Create instance: proc_sys_reset_0_100M, and set properties
  set proc_sys_reset_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0_100M ]

  # Create instance: proc_sys_reset_1_142M, and set properties
  set proc_sys_reset_1_142M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1_142M ]

  # Create instance: proc_sys_reset_2_200M, and set properties
  set proc_sys_reset_2_200M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2_200M ]

  # Create instance: proc_sys_reset_3_166M, and set properties
  set proc_sys_reset_3_166M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3_166M ]

  # Create instance: ps7, and set properties
  set ps7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7 ]
  set_property -dict [ list \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {142.857132} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
CONFIG.PCW_CAN0_CAN0_IO {<Select>} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN0_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN1_CAN1_IO {<Select>} \
CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN1_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_CLK0_FREQ {100000000} \
CONFIG.PCW_CLK1_FREQ {142857132} \
CONFIG.PCW_CLK2_FREQ {200000000} \
CONFIG.PCW_CLK3_FREQ {166666672} \
CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PRIORITY_READPORT_0 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_1 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_2 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_3 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3 {<Select>} \
CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_ENET0_ENET0_IO {<Select>} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {0} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {<Select>} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_ENET0_RESET_IO {<Select>} \
CONFIG.PCW_ENET1_ENET1_IO {<Select>} \
CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
CONFIG.PCW_ENET1_GRP_MDIO_IO {<Select>} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET1_RESET_ENABLE {0} \
CONFIG.PCW_ENET1_RESET_IO {<Select>} \
CONFIG.PCW_ENET_RESET_ENABLE {0} \
CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
CONFIG.PCW_ENET_RESET_SELECT {<Select>} \
CONFIG.PCW_EN_4K_TIMER {0} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_EN_CLK3_PORT {1} \
CONFIG.PCW_EN_CLKTRIG0_PORT {1} \
CONFIG.PCW_EN_GPIO {0} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {7} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {6} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
CONFIG.PCW_FCLK_CLK3_BUF {TRUE} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {142} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {166} \
CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK3_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_MIO_GPIO_IO {<Select>} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C0_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C0_I2C0_IO {<Select>} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C0_RESET_ENABLE {0} \
CONFIG.PCW_I2C0_RESET_IO {<Select>} \
CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C1_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C1_I2C1_IO {<Select>} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_IO {<Select>} \
CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
CONFIG.PCW_I2C_RESET_SELECT {<Select>} \
CONFIG.PCW_IMPORT_BOARD_PRESET {C:/Users/tkato/Desktop/pynq-zynq.tcl} \
CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_DIRECTION {<Select>} \
CONFIG.PCW_MIO_0_IOTYPE {<Select>} \
CONFIG.PCW_MIO_0_PULLUP {<Select>} \
CONFIG.PCW_MIO_0_SLEW {<Select>} \
CONFIG.PCW_MIO_10_DIRECTION {<Select>} \
CONFIG.PCW_MIO_10_IOTYPE {<Select>} \
CONFIG.PCW_MIO_10_PULLUP {<Select>} \
CONFIG.PCW_MIO_10_SLEW {<Select>} \
CONFIG.PCW_MIO_11_DIRECTION {<Select>} \
CONFIG.PCW_MIO_11_IOTYPE {<Select>} \
CONFIG.PCW_MIO_11_PULLUP {<Select>} \
CONFIG.PCW_MIO_11_SLEW {<Select>} \
CONFIG.PCW_MIO_12_DIRECTION {<Select>} \
CONFIG.PCW_MIO_12_IOTYPE {<Select>} \
CONFIG.PCW_MIO_12_PULLUP {<Select>} \
CONFIG.PCW_MIO_12_SLEW {<Select>} \
CONFIG.PCW_MIO_13_DIRECTION {<Select>} \
CONFIG.PCW_MIO_13_IOTYPE {<Select>} \
CONFIG.PCW_MIO_13_PULLUP {<Select>} \
CONFIG.PCW_MIO_13_SLEW {<Select>} \
CONFIG.PCW_MIO_14_DIRECTION {<Select>} \
CONFIG.PCW_MIO_14_IOTYPE {<Select>} \
CONFIG.PCW_MIO_14_PULLUP {<Select>} \
CONFIG.PCW_MIO_14_SLEW {<Select>} \
CONFIG.PCW_MIO_15_DIRECTION {<Select>} \
CONFIG.PCW_MIO_15_IOTYPE {<Select>} \
CONFIG.PCW_MIO_15_PULLUP {<Select>} \
CONFIG.PCW_MIO_15_SLEW {<Select>} \
CONFIG.PCW_MIO_16_DIRECTION {<Select>} \
CONFIG.PCW_MIO_16_IOTYPE {<Select>} \
CONFIG.PCW_MIO_16_PULLUP {<Select>} \
CONFIG.PCW_MIO_16_SLEW {<Select>} \
CONFIG.PCW_MIO_17_DIRECTION {<Select>} \
CONFIG.PCW_MIO_17_IOTYPE {<Select>} \
CONFIG.PCW_MIO_17_PULLUP {<Select>} \
CONFIG.PCW_MIO_17_SLEW {<Select>} \
CONFIG.PCW_MIO_18_DIRECTION {<Select>} \
CONFIG.PCW_MIO_18_IOTYPE {<Select>} \
CONFIG.PCW_MIO_18_PULLUP {<Select>} \
CONFIG.PCW_MIO_18_SLEW {<Select>} \
CONFIG.PCW_MIO_19_DIRECTION {<Select>} \
CONFIG.PCW_MIO_19_IOTYPE {<Select>} \
CONFIG.PCW_MIO_19_PULLUP {<Select>} \
CONFIG.PCW_MIO_19_SLEW {<Select>} \
CONFIG.PCW_MIO_1_DIRECTION {<Select>} \
CONFIG.PCW_MIO_1_IOTYPE {<Select>} \
CONFIG.PCW_MIO_1_PULLUP {<Select>} \
CONFIG.PCW_MIO_1_SLEW {<Select>} \
CONFIG.PCW_MIO_20_DIRECTION {<Select>} \
CONFIG.PCW_MIO_20_IOTYPE {<Select>} \
CONFIG.PCW_MIO_20_PULLUP {<Select>} \
CONFIG.PCW_MIO_20_SLEW {<Select>} \
CONFIG.PCW_MIO_21_DIRECTION {<Select>} \
CONFIG.PCW_MIO_21_IOTYPE {<Select>} \
CONFIG.PCW_MIO_21_PULLUP {<Select>} \
CONFIG.PCW_MIO_21_SLEW {<Select>} \
CONFIG.PCW_MIO_22_DIRECTION {<Select>} \
CONFIG.PCW_MIO_22_IOTYPE {<Select>} \
CONFIG.PCW_MIO_22_PULLUP {<Select>} \
CONFIG.PCW_MIO_22_SLEW {<Select>} \
CONFIG.PCW_MIO_23_DIRECTION {<Select>} \
CONFIG.PCW_MIO_23_IOTYPE {<Select>} \
CONFIG.PCW_MIO_23_PULLUP {<Select>} \
CONFIG.PCW_MIO_23_SLEW {<Select>} \
CONFIG.PCW_MIO_24_DIRECTION {<Select>} \
CONFIG.PCW_MIO_24_IOTYPE {<Select>} \
CONFIG.PCW_MIO_24_PULLUP {<Select>} \
CONFIG.PCW_MIO_24_SLEW {<Select>} \
CONFIG.PCW_MIO_25_DIRECTION {<Select>} \
CONFIG.PCW_MIO_25_IOTYPE {<Select>} \
CONFIG.PCW_MIO_25_PULLUP {<Select>} \
CONFIG.PCW_MIO_25_SLEW {<Select>} \
CONFIG.PCW_MIO_26_DIRECTION {<Select>} \
CONFIG.PCW_MIO_26_IOTYPE {<Select>} \
CONFIG.PCW_MIO_26_PULLUP {<Select>} \
CONFIG.PCW_MIO_26_SLEW {<Select>} \
CONFIG.PCW_MIO_27_DIRECTION {<Select>} \
CONFIG.PCW_MIO_27_IOTYPE {<Select>} \
CONFIG.PCW_MIO_27_PULLUP {<Select>} \
CONFIG.PCW_MIO_27_SLEW {<Select>} \
CONFIG.PCW_MIO_28_DIRECTION {<Select>} \
CONFIG.PCW_MIO_28_IOTYPE {<Select>} \
CONFIG.PCW_MIO_28_PULLUP {<Select>} \
CONFIG.PCW_MIO_28_SLEW {<Select>} \
CONFIG.PCW_MIO_29_DIRECTION {<Select>} \
CONFIG.PCW_MIO_29_IOTYPE {<Select>} \
CONFIG.PCW_MIO_29_PULLUP {<Select>} \
CONFIG.PCW_MIO_29_SLEW {<Select>} \
CONFIG.PCW_MIO_2_DIRECTION {<Select>} \
CONFIG.PCW_MIO_2_IOTYPE {<Select>} \
CONFIG.PCW_MIO_2_PULLUP {<Select>} \
CONFIG.PCW_MIO_2_SLEW {<Select>} \
CONFIG.PCW_MIO_30_DIRECTION {<Select>} \
CONFIG.PCW_MIO_30_IOTYPE {<Select>} \
CONFIG.PCW_MIO_30_PULLUP {<Select>} \
CONFIG.PCW_MIO_30_SLEW {<Select>} \
CONFIG.PCW_MIO_31_DIRECTION {<Select>} \
CONFIG.PCW_MIO_31_IOTYPE {<Select>} \
CONFIG.PCW_MIO_31_PULLUP {<Select>} \
CONFIG.PCW_MIO_31_SLEW {<Select>} \
CONFIG.PCW_MIO_32_DIRECTION {<Select>} \
CONFIG.PCW_MIO_32_IOTYPE {<Select>} \
CONFIG.PCW_MIO_32_PULLUP {<Select>} \
CONFIG.PCW_MIO_32_SLEW {<Select>} \
CONFIG.PCW_MIO_33_DIRECTION {<Select>} \
CONFIG.PCW_MIO_33_IOTYPE {<Select>} \
CONFIG.PCW_MIO_33_PULLUP {<Select>} \
CONFIG.PCW_MIO_33_SLEW {<Select>} \
CONFIG.PCW_MIO_34_DIRECTION {<Select>} \
CONFIG.PCW_MIO_34_IOTYPE {<Select>} \
CONFIG.PCW_MIO_34_PULLUP {<Select>} \
CONFIG.PCW_MIO_34_SLEW {<Select>} \
CONFIG.PCW_MIO_35_DIRECTION {<Select>} \
CONFIG.PCW_MIO_35_IOTYPE {<Select>} \
CONFIG.PCW_MIO_35_PULLUP {<Select>} \
CONFIG.PCW_MIO_35_SLEW {<Select>} \
CONFIG.PCW_MIO_36_DIRECTION {<Select>} \
CONFIG.PCW_MIO_36_IOTYPE {<Select>} \
CONFIG.PCW_MIO_36_PULLUP {<Select>} \
CONFIG.PCW_MIO_36_SLEW {<Select>} \
CONFIG.PCW_MIO_37_DIRECTION {<Select>} \
CONFIG.PCW_MIO_37_IOTYPE {<Select>} \
CONFIG.PCW_MIO_37_PULLUP {<Select>} \
CONFIG.PCW_MIO_37_SLEW {<Select>} \
CONFIG.PCW_MIO_38_DIRECTION {<Select>} \
CONFIG.PCW_MIO_38_IOTYPE {<Select>} \
CONFIG.PCW_MIO_38_PULLUP {<Select>} \
CONFIG.PCW_MIO_38_SLEW {<Select>} \
CONFIG.PCW_MIO_39_DIRECTION {<Select>} \
CONFIG.PCW_MIO_39_IOTYPE {<Select>} \
CONFIG.PCW_MIO_39_PULLUP {<Select>} \
CONFIG.PCW_MIO_39_SLEW {<Select>} \
CONFIG.PCW_MIO_3_DIRECTION {<Select>} \
CONFIG.PCW_MIO_3_IOTYPE {<Select>} \
CONFIG.PCW_MIO_3_PULLUP {<Select>} \
CONFIG.PCW_MIO_3_SLEW {<Select>} \
CONFIG.PCW_MIO_40_DIRECTION {<Select>} \
CONFIG.PCW_MIO_40_IOTYPE {<Select>} \
CONFIG.PCW_MIO_40_PULLUP {<Select>} \
CONFIG.PCW_MIO_40_SLEW {<Select>} \
CONFIG.PCW_MIO_41_DIRECTION {<Select>} \
CONFIG.PCW_MIO_41_IOTYPE {<Select>} \
CONFIG.PCW_MIO_41_PULLUP {<Select>} \
CONFIG.PCW_MIO_41_SLEW {<Select>} \
CONFIG.PCW_MIO_42_DIRECTION {<Select>} \
CONFIG.PCW_MIO_42_IOTYPE {<Select>} \
CONFIG.PCW_MIO_42_PULLUP {<Select>} \
CONFIG.PCW_MIO_42_SLEW {<Select>} \
CONFIG.PCW_MIO_43_DIRECTION {<Select>} \
CONFIG.PCW_MIO_43_IOTYPE {<Select>} \
CONFIG.PCW_MIO_43_PULLUP {<Select>} \
CONFIG.PCW_MIO_43_SLEW {<Select>} \
CONFIG.PCW_MIO_44_DIRECTION {<Select>} \
CONFIG.PCW_MIO_44_IOTYPE {<Select>} \
CONFIG.PCW_MIO_44_PULLUP {<Select>} \
CONFIG.PCW_MIO_44_SLEW {<Select>} \
CONFIG.PCW_MIO_45_DIRECTION {<Select>} \
CONFIG.PCW_MIO_45_IOTYPE {<Select>} \
CONFIG.PCW_MIO_45_PULLUP {<Select>} \
CONFIG.PCW_MIO_45_SLEW {<Select>} \
CONFIG.PCW_MIO_46_DIRECTION {<Select>} \
CONFIG.PCW_MIO_46_IOTYPE {<Select>} \
CONFIG.PCW_MIO_46_PULLUP {<Select>} \
CONFIG.PCW_MIO_46_SLEW {<Select>} \
CONFIG.PCW_MIO_47_DIRECTION {<Select>} \
CONFIG.PCW_MIO_47_IOTYPE {<Select>} \
CONFIG.PCW_MIO_47_PULLUP {<Select>} \
CONFIG.PCW_MIO_47_SLEW {<Select>} \
CONFIG.PCW_MIO_48_DIRECTION {<Select>} \
CONFIG.PCW_MIO_48_IOTYPE {<Select>} \
CONFIG.PCW_MIO_48_PULLUP {<Select>} \
CONFIG.PCW_MIO_48_SLEW {<Select>} \
CONFIG.PCW_MIO_49_DIRECTION {<Select>} \
CONFIG.PCW_MIO_49_IOTYPE {<Select>} \
CONFIG.PCW_MIO_49_PULLUP {<Select>} \
CONFIG.PCW_MIO_49_SLEW {<Select>} \
CONFIG.PCW_MIO_4_DIRECTION {<Select>} \
CONFIG.PCW_MIO_4_IOTYPE {<Select>} \
CONFIG.PCW_MIO_4_PULLUP {<Select>} \
CONFIG.PCW_MIO_4_SLEW {<Select>} \
CONFIG.PCW_MIO_50_DIRECTION {<Select>} \
CONFIG.PCW_MIO_50_IOTYPE {<Select>} \
CONFIG.PCW_MIO_50_PULLUP {<Select>} \
CONFIG.PCW_MIO_50_SLEW {<Select>} \
CONFIG.PCW_MIO_51_DIRECTION {<Select>} \
CONFIG.PCW_MIO_51_IOTYPE {<Select>} \
CONFIG.PCW_MIO_51_PULLUP {<Select>} \
CONFIG.PCW_MIO_51_SLEW {<Select>} \
CONFIG.PCW_MIO_52_DIRECTION {<Select>} \
CONFIG.PCW_MIO_52_IOTYPE {<Select>} \
CONFIG.PCW_MIO_52_PULLUP {<Select>} \
CONFIG.PCW_MIO_52_SLEW {<Select>} \
CONFIG.PCW_MIO_53_DIRECTION {<Select>} \
CONFIG.PCW_MIO_53_IOTYPE {<Select>} \
CONFIG.PCW_MIO_53_PULLUP {<Select>} \
CONFIG.PCW_MIO_53_SLEW {<Select>} \
CONFIG.PCW_MIO_5_DIRECTION {<Select>} \
CONFIG.PCW_MIO_5_IOTYPE {<Select>} \
CONFIG.PCW_MIO_5_PULLUP {<Select>} \
CONFIG.PCW_MIO_5_SLEW {<Select>} \
CONFIG.PCW_MIO_6_DIRECTION {<Select>} \
CONFIG.PCW_MIO_6_IOTYPE {<Select>} \
CONFIG.PCW_MIO_6_PULLUP {<Select>} \
CONFIG.PCW_MIO_6_SLEW {<Select>} \
CONFIG.PCW_MIO_7_DIRECTION {<Select>} \
CONFIG.PCW_MIO_7_IOTYPE {<Select>} \
CONFIG.PCW_MIO_7_PULLUP {<Select>} \
CONFIG.PCW_MIO_7_SLEW {<Select>} \
CONFIG.PCW_MIO_8_DIRECTION {<Select>} \
CONFIG.PCW_MIO_8_IOTYPE {<Select>} \
CONFIG.PCW_MIO_8_PULLUP {<Select>} \
CONFIG.PCW_MIO_8_SLEW {<Select>} \
CONFIG.PCW_MIO_9_DIRECTION {<Select>} \
CONFIG.PCW_MIO_9_IOTYPE {<Select>} \
CONFIG.PCW_MIO_9_PULLUP {<Select>} \
CONFIG.PCW_MIO_9_SLEW {<Select>} \
CONFIG.PCW_MIO_TREE_PERIPHERALS {unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned} \
CONFIG.PCW_MIO_TREE_SIGNALS {unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned} \
CONFIG.PCW_NAND_CYCLES_T_AR {1} \
CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
CONFIG.PCW_NAND_CYCLES_T_RC {11} \
CONFIG.PCW_NAND_CYCLES_T_REA {1} \
CONFIG.PCW_NAND_CYCLES_T_RR {1} \
CONFIG.PCW_NAND_CYCLES_T_WC {11} \
CONFIG.PCW_NAND_CYCLES_T_WP {1} \
CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
CONFIG.PCW_NAND_GRP_D8_IO {<Select>} \
CONFIG.PCW_NAND_NAND_IO {<Select>} \
CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_CS0_T_PC {1} \
CONFIG.PCW_NOR_CS0_T_RC {11} \
CONFIG.PCW_NOR_CS0_T_TR {1} \
CONFIG.PCW_NOR_CS0_T_WC {11} \
CONFIG.PCW_NOR_CS0_T_WP {1} \
CONFIG.PCW_NOR_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_CS1_T_PC {1} \
CONFIG.PCW_NOR_CS1_T_RC {11} \
CONFIG.PCW_NOR_CS1_T_TR {1} \
CONFIG.PCW_NOR_CS1_T_WC {11} \
CONFIG.PCW_NOR_CS1_T_WP {1} \
CONFIG.PCW_NOR_CS1_WE_TIME {0} \
CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
CONFIG.PCW_NOR_GRP_A25_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_INT_IO {<Select>} \
CONFIG.PCW_NOR_NOR_IO {<Select>} \
CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.089} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.075} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.085} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.092} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.025} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.014} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
CONFIG.PCW_PACKAGE_NAME {clg400} \
CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_PJTAG_PJTAG_IO {<Select>} \
CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {<Select>} \
CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_IO1_IO {<Select>} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {<Select>} \
CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_SS1_IO {<Select>} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_QSPI_QSPI_IO {<Select>} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {0} \
CONFIG.PCW_SD0_GRP_CD_IO {<Select>} \
CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD0_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
CONFIG.PCW_SD0_GRP_WP_IO {<Select>} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SD0_SD0_IO {<Select>} \
CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
CONFIG.PCW_SD1_GRP_CD_IO {<Select>} \
CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD1_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
CONFIG.PCW_SD1_GRP_WP_IO {<Select>} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SD1_SD1_IO {<Select>} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
CONFIG.PCW_SPI0_GRP_SS0_IO {<Select>} \
CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
CONFIG.PCW_SPI0_GRP_SS1_IO {<Select>} \
CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI0_GRP_SS2_IO {<Select>} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SPI0_SPI0_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS0_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS1_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS2_IO {<Select>} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SPI1_SPI1_IO {<Select>} \
CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_16BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_2BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_32BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_4BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_8BIT_IO {<Select>} \
CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TRACE_TRACE_IO {<Select>} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC0_TTC0_IO {<Select>} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC1_TTC1_IO {<Select>} \
CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART0_BAUD_RATE {115200} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART0_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART0_UART0_IO {<Select>} \
CONFIG.PCW_UART1_BAUD_RATE {115200} \
CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART1_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART1_UART1_IO {<Select>} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
CONFIG.PCW_UIPARAM_DDR_AL {0} \
CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
CONFIG.PCW_UIPARAM_DDR_BL {8} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
CONFIG.PCW_UIPARAM_DDR_CL {7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {80.4535} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {80.4535} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {80.4535} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {80.4535} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
CONFIG.PCW_UIPARAM_DDR_CWL {6} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {1024 MBits} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {105.056} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {66.904} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {89.1715} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {113.63} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {98.503} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {68.5855} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {90.295} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {103.977} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {8 Bits} \
CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M8 JP-125} \
CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_T_FAW {30.0} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB0_RESET_ENABLE {0} \
CONFIG.PCW_USB0_RESET_IO {<Select>} \
CONFIG.PCW_USB0_USB0_IO {<Select>} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB1_RESET_ENABLE {0} \
CONFIG.PCW_USB1_RESET_IO {<Select>} \
CONFIG.PCW_USB1_USB1_IO {<Select>} \
CONFIG.PCW_USB_RESET_ENABLE {0} \
CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
CONFIG.PCW_USB_RESET_SELECT {<Select>} \
CONFIG.PCW_USE_CROSS_TRIGGER {0} \
CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP0 {1} \
CONFIG.PCW_USE_S_AXI_ACP {1} \
CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_WDT_WDT_IO {<Select>} \
 ] $ps7

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ARMPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_CAN0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_GRP_CLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_CAN1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_GRP_CLK_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_GRP_CLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK0_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK1_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK2_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK3_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_CPU_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDRPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_DDR_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT0_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT1_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT2_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT3_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_RAM_HIGHADDR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_GRP_MDIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_ENET1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_GRP_MDIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_GRP_MDIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_4K_TIMER.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_GPIO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK0_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK1_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK2_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK3_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK3_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_MIO_GPIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_GRP_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_GRP_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_I2C0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_GRP_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_GRP_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_I2C1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_IOPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_IO_IO_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_TREE_PERIPHERALS.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_TREE_SIGNALS.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_AR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_CLR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_REA.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_RR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_GRP_D8_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_GRP_D8_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_NAND_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_A25_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_A25_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_NOR_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_NAME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PJTAG_PJTAG_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PLL_BYPASSMODE_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_IO1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_IO1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_QSPI_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_CD_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_POW_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_POW_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_WP_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_WP_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_SD0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_CD_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_CD_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_POW_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_POW_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_WP_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_WP_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_SD1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS2_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_SPI0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS2_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_SPI1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_16BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_16BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_2BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_2BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_32BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_32BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_4BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_4BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_8BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_8BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_INTERNAL_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_TRACE_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_TTC0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_TTC1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_BAUD_RATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_GRP_FULL_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_BAUD_RATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_GRP_FULL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_GRP_FULL_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_UART1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_AL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ECC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_USB0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_USB1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USE_CROSS_TRIGGER.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_WDT_IO.VALUE_SRC {DEFAULT} \
 ] $ps7

  # Create instance: ps7_irq_const, and set properties
  set ps7_irq_const [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ps7_irq_const ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {1} \
 ] $ps7_irq_const

  # Create instance: xlconcat, and set properties
  set xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {1} \
 ] $xlconcat

  # Create interface connections
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M00_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M00_AXI] [get_bd_intf_pins mmult_accel_1_if/S_AXI]
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M01_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M01_AXI] [get_bd_intf_pins dm_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M02_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M02_AXI] [get_bd_intf_pins dm_1/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M03_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M03_AXI] [get_bd_intf_pins dm_2/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_ps7_S_AXI_ACP_M00_AXI [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/M00_AXI] [get_bd_intf_pins ps7/S_AXI_ACP]
  connect_bd_intf_net -intf_net dm_0_M_AXIS_MM2S [get_bd_intf_pins dm_0/M_AXIS_MM2S] [get_bd_intf_pins mmult_accel_1_if/S_AXIS_FIFO_0]
  connect_bd_intf_net -intf_net dm_0_M_AXI_MM2S [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/S00_AXI] [get_bd_intf_pins dm_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net dm_1_M_AXIS_MM2S [get_bd_intf_pins dm_1/M_AXIS_MM2S] [get_bd_intf_pins mmult_accel_1_if/S_AXIS_FIFO_1]
  connect_bd_intf_net -intf_net dm_1_M_AXI_MM2S [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/S01_AXI] [get_bd_intf_pins dm_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net dm_2_M_AXI_S2MM [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/S02_AXI] [get_bd_intf_pins dm_2/M_AXI_S2MM]
  connect_bd_intf_net -intf_net mmult_accel_1_A [get_bd_intf_pins mmult_accel_1/A] [get_bd_intf_pins mmult_accel_1_if/AP_FIFO_IARG_0]
  connect_bd_intf_net -intf_net mmult_accel_1_B [get_bd_intf_pins mmult_accel_1/B] [get_bd_intf_pins mmult_accel_1_if/AP_FIFO_IARG_1]
  connect_bd_intf_net -intf_net mmult_accel_1_C [get_bd_intf_pins mmult_accel_1/C] [get_bd_intf_pins mmult_accel_1_if/AP_FIFO_OARG_0]
  connect_bd_intf_net -intf_net mmult_accel_1_if_M_AXIS_FIFO_0 [get_bd_intf_pins dm_2/S_AXIS_S2MM] [get_bd_intf_pins mmult_accel_1_if/M_AXIS_FIFO_0]
  connect_bd_intf_net -intf_net mmult_accel_1_if_ap_ctrl [get_bd_intf_pins mmult_accel_1/ap_ctrl] [get_bd_intf_pins mmult_accel_1_if/ap_ctrl]
  connect_bd_intf_net -intf_net ps7_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps7/DDR]
  connect_bd_intf_net -intf_net ps7_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps7/FIXED_IO]
  connect_bd_intf_net -intf_net ps7_M_AXI_GP0 [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/S00_AXI] [get_bd_intf_pins ps7/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net acp_axcache_0xE_dout [get_bd_pins acp_axcache_0xE/dout] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S00_AXI_arcache] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S01_AXI_arcache] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S02_AXI_awcache]
  connect_bd_net -net mmult_accel_1_if_aresetn [get_bd_pins mmult_accel_1/ap_rst_n] [get_bd_pins mmult_accel_1_if/aresetn]
  connect_bd_net -net proc_sys_reset_0_100M_interconnect_aresetn [get_bd_pins axi_ic_ps7_M_AXI_GP0/ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/ARESETN] [get_bd_pins proc_sys_reset_0_100M/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_100M_peripheral_aresetn [get_bd_pins axi_ic_ps7_M_AXI_GP0/M00_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M01_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M02_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M03_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/S00_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/M00_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S00_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S01_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S02_ARESETN] [get_bd_pins dm_0/axi_resetn] [get_bd_pins dm_1/axi_resetn] [get_bd_pins dm_2/axi_resetn] [get_bd_pins mmult_accel_1_if/resetn] [get_bd_pins mmult_accel_1_if/s_axi_aresetn] [get_bd_pins proc_sys_reset_0_100M/peripheral_aresetn]
  connect_bd_net -net ps7_FCLK_CLK0 [get_bd_pins axi_ic_ps7_M_AXI_GP0/ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M00_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M01_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M02_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M03_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/S00_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/M00_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S00_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S01_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S02_ACLK] [get_bd_pins dm_0/m_axi_mm2s_aclk] [get_bd_pins dm_0/s_axi_lite_aclk] [get_bd_pins dm_1/m_axi_mm2s_aclk] [get_bd_pins dm_1/s_axi_lite_aclk] [get_bd_pins dm_2/m_axi_s2mm_aclk] [get_bd_pins dm_2/s_axi_lite_aclk] [get_bd_pins mmult_accel_1/ap_clk] [get_bd_pins mmult_accel_1_if/aclk] [get_bd_pins mmult_accel_1_if/s_axi_aclk] [get_bd_pins proc_sys_reset_0_100M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK0] [get_bd_pins ps7/M_AXI_GP0_ACLK] [get_bd_pins ps7/S_AXI_ACP_ACLK]
  connect_bd_net -net ps7_FCLK_CLK1 [get_bd_pins proc_sys_reset_1_142M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK1]
  connect_bd_net -net ps7_FCLK_CLK2 [get_bd_pins proc_sys_reset_2_200M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK2]
  connect_bd_net -net ps7_FCLK_CLK3 [get_bd_pins proc_sys_reset_3_166M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK3]
  connect_bd_net -net ps7_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0_100M/ext_reset_in] [get_bd_pins proc_sys_reset_1_142M/ext_reset_in] [get_bd_pins proc_sys_reset_2_200M/ext_reset_in] [get_bd_pins proc_sys_reset_3_166M/ext_reset_in] [get_bd_pins ps7/FCLK_RESET0_N]
  connect_bd_net -net ps7_irq_const_dout [get_bd_pins ps7_irq_const/dout] [get_bd_pins xlconcat/In0]
  connect_bd_net -net xlconcat_dout [get_bd_pins ps7/IRQ_F2P] [get_bd_pins xlconcat/dout]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces dm_0/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_ps7_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces dm_0/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_M_AXI_GP0] SEG_ps7_ACP_M_AXI_GP0
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces dm_1/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_ps7_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces dm_1/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_M_AXI_GP0] SEG_ps7_ACP_M_AXI_GP0
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces dm_2/Data_S2MM] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_ps7_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces dm_2/Data_S2MM] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_M_AXI_GP0] SEG_ps7_ACP_M_AXI_GP0
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs dm_0/S_AXI_LITE/Reg] SEG_dm_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40410000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs dm_1/S_AXI_LITE/Reg] SEG_dm_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40420000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs dm_2/S_AXI_LITE/Reg] SEG_dm_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs mmult_accel_1_if/S_AXI/reg0] SEG_mmult_accel_1_if_reg0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 330 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 350 -defaultsOSRD
preplace inst proc_sys_reset_2_200M -pg 1 -lvl 3 -y 440 -defaultsOSRD
preplace inst ps7 -pg 1 -lvl 2 -y 420 -defaultsOSRD
preplace inst proc_sys_reset_0_100M -pg 1 -lvl 3 -y 80 -defaultsOSRD
preplace inst xlconcat -pg 1 -lvl 1 -y 410 -defaultsOSRD
preplace inst proc_sys_reset_1_142M -pg 1 -lvl 3 -y 240 -defaultsOSRD
preplace inst proc_sys_reset_3_166M -pg 1 -lvl 3 -y 600 -defaultsOSRD
preplace netloc ps7_FIXED_IO 1 2 2 550J 350 NJ
preplace netloc ps7_FCLK_CLK0 1 2 1 520
preplace netloc ps7_FCLK_CLK1 1 2 1 540
preplace netloc ps7_DDR 1 2 2 530J 330 NJ
preplace netloc ps7_FCLK_CLK2 1 2 1 570
preplace netloc xlconcat_dout 1 1 1 170
preplace netloc ps7_FCLK_CLK3 1 2 1 530
preplace netloc ps7_FCLK_RESET0_N 1 2 1 560
levelinfo -pg 1 -10 90 360 740 910 -top 0 -bot 690
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


