
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg400-1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
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

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
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

  # Create instance: acp_axcache_0xF, and set properties
  set acp_axcache_0xF [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 acp_axcache_0xF ]
  set_property -dict [ list \
CONFIG.CONST_VAL {15} \
CONFIG.CONST_WIDTH {4} \
 ] $acp_axcache_0xF

  # Create instance: axi_ic_ps7_M_AXI_GP0, and set properties
  set axi_ic_ps7_M_AXI_GP0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ps7_M_AXI_GP0 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.M02_HAS_REGSLICE {1} \
CONFIG.M03_HAS_REGSLICE {1} \
CONFIG.NUM_MI {4} \
CONFIG.NUM_SI {1} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.STRATEGY {2} \
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
CONFIG.c_s_axis_s2mm_tdata_width {64} \
CONFIG.c_sg_length_width {23} \
 ] $dm_2

  # Create instance: mmult_accel_0, and set properties
  set mmult_accel_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mmult_accel:1.0 mmult_accel_0 ]

  # Create instance: mmult_accel_0_if, and set properties
  set mmult_accel_0_if [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_accelerator_adapter:2.1 mmult_accel_0_if ]
  set_property -dict [ list \
CONFIG.C_AP_IARG_0_DIM_1 {1024} \
CONFIG.C_AP_IARG_0_DWIDTH {32} \
CONFIG.C_AP_IARG_0_TYPE {1} \
CONFIG.C_AP_IARG_0_WIDTH {32} \
CONFIG.C_AP_IARG_1_DIM_1 {1024} \
CONFIG.C_AP_IARG_1_DWIDTH {32} \
CONFIG.C_AP_IARG_1_TYPE {1} \
CONFIG.C_AP_IARG_1_WIDTH {32} \
CONFIG.C_AP_OARG_0_DIM_1 {1024} \
CONFIG.C_AP_OARG_0_DWIDTH {32} \
CONFIG.C_AP_OARG_0_TYPE {1} \
CONFIG.C_AP_OARG_0_WIDTH {32} \
CONFIG.C_M_AXIS_HAS_TKEEP {1} \
CONFIG.C_M_AXIS_HAS_TSTRB {1} \
CONFIG.C_M_AXIS_TDATA_WIDTH {64} \
CONFIG.C_N_INPUT_ARGS {2} \
CONFIG.C_N_OUTPUT_ARGS {1} \
CONFIG.C_S_AXIS_TDATA_WIDTH {64} \
 ] $mmult_accel_0_if

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
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {650} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_EN_CLK3_PORT {1} \
CONFIG.PCW_EN_CLKTRIG0_PORT {1} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {142} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {160} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_IMPORT_BOARD_PRESET {C:/Users/tkato/Desktop/pynq-zynq.tcl} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.223} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.212} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.085} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.092} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
CONFIG.PCW_UIPARAM_DDR_CWL {6} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.040} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.058} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {525} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {Custom} \
CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
CONFIG.PCW_UIPARAM_DDR_T_RC {50.625} \
CONFIG.PCW_UIPARAM_DDR_T_RCD {13.125} \
CONFIG.PCW_UIPARAM_DDR_T_RP {13.125} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP0 {1} \
CONFIG.PCW_USE_S_AXI_ACP {1} \
 ] $ps7

  # Create instance: xlconcat, and set properties
  set xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat

  # Create interface connections
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M00_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M00_AXI] [get_bd_intf_pins mmult_accel_0_if/S_AXI]
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M01_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M01_AXI] [get_bd_intf_pins dm_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M02_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M02_AXI] [get_bd_intf_pins dm_1/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_ps7_M_AXI_GP0_M03_AXI [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/M03_AXI] [get_bd_intf_pins dm_2/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_ps7_S_AXI_ACP_M00_AXI [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/M00_AXI] [get_bd_intf_pins ps7/S_AXI_ACP]
  connect_bd_intf_net -intf_net dm_0_M_AXIS_MM2S [get_bd_intf_pins dm_0/M_AXIS_MM2S] [get_bd_intf_pins mmult_accel_0_if/S_AXIS_1]
  connect_bd_intf_net -intf_net dm_0_M_AXI_MM2S [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/S00_AXI] [get_bd_intf_pins dm_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net dm_1_M_AXIS_MM2S [get_bd_intf_pins dm_1/M_AXIS_MM2S] [get_bd_intf_pins mmult_accel_0_if/S_AXIS_0]
  connect_bd_intf_net -intf_net dm_1_M_AXI_MM2S [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/S01_AXI] [get_bd_intf_pins dm_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net dm_2_M_AXI_S2MM [get_bd_intf_pins axi_ic_ps7_S_AXI_ACP/S02_AXI] [get_bd_intf_pins dm_2/M_AXI_S2MM]
  connect_bd_intf_net -intf_net mmult_accel_0_if_AP_CTRL [get_bd_intf_pins mmult_accel_0/ap_ctrl] [get_bd_intf_pins mmult_accel_0_if/AP_CTRL]
  connect_bd_intf_net -intf_net mmult_accel_0_if_M_AXIS_0 [get_bd_intf_pins dm_2/S_AXIS_S2MM] [get_bd_intf_pins mmult_accel_0_if/M_AXIS_0]
  connect_bd_intf_net -intf_net mmult_accel_0_in_A [get_bd_intf_pins mmult_accel_0/in_A] [get_bd_intf_pins mmult_accel_0_if/AP_FIFO_IARG_0]
  connect_bd_intf_net -intf_net mmult_accel_0_in_B [get_bd_intf_pins mmult_accel_0/in_B] [get_bd_intf_pins mmult_accel_0_if/AP_FIFO_IARG_1]
  connect_bd_intf_net -intf_net mmult_accel_0_out_C [get_bd_intf_pins mmult_accel_0/out_C] [get_bd_intf_pins mmult_accel_0_if/AP_FIFO_OARG_0]
  connect_bd_intf_net -intf_net ps7_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps7/DDR]
  connect_bd_intf_net -intf_net ps7_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps7/FIXED_IO]
  connect_bd_intf_net -intf_net ps7_M_AXI_GP0 [get_bd_intf_pins axi_ic_ps7_M_AXI_GP0/S00_AXI] [get_bd_intf_pins ps7/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net acp_axcache_0xF_dout [get_bd_pins acp_axcache_0xF/dout] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S00_AXI_arcache] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S01_AXI_arcache] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S02_AXI_awcache]
  connect_bd_net -net dm_0_mm2s_introut [get_bd_pins dm_0/mm2s_introut] [get_bd_pins xlconcat/In0]
  connect_bd_net -net dm_1_mm2s_introut [get_bd_pins dm_1/mm2s_introut] [get_bd_pins xlconcat/In1]
  connect_bd_net -net dm_2_s2mm_introut [get_bd_pins dm_2/s2mm_introut] [get_bd_pins xlconcat/In2]
  connect_bd_net -net mmult_accel_0_if_aresetn [get_bd_pins mmult_accel_0/ap_rst_n] [get_bd_pins mmult_accel_0_if/aresetn]
  connect_bd_net -net proc_sys_reset_2_200M_interconnect_aresetn [get_bd_pins axi_ic_ps7_M_AXI_GP0/ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M00_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M01_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M02_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M03_ARESETN] [get_bd_pins axi_ic_ps7_M_AXI_GP0/S00_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/M00_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S00_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S01_ARESETN] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S02_ARESETN] [get_bd_pins proc_sys_reset_2_200M/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_2_200M_peripheral_aresetn [get_bd_pins dm_0/axi_resetn] [get_bd_pins dm_1/axi_resetn] [get_bd_pins dm_2/axi_resetn] [get_bd_pins mmult_accel_0_if/m_axis_aresetn] [get_bd_pins mmult_accel_0_if/s_axi_aresetn] [get_bd_pins mmult_accel_0_if/s_axis_aresetn] [get_bd_pins proc_sys_reset_2_200M/peripheral_aresetn]
  connect_bd_net -net ps7_FCLK_CLK0 [get_bd_pins proc_sys_reset_0_100M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK0]
  connect_bd_net -net ps7_FCLK_CLK1 [get_bd_pins proc_sys_reset_1_142M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK1]
  connect_bd_net -net ps7_FCLK_CLK2 [get_bd_pins axi_ic_ps7_M_AXI_GP0/ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M00_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M01_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M02_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/M03_ACLK] [get_bd_pins axi_ic_ps7_M_AXI_GP0/S00_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/M00_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S00_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S01_ACLK] [get_bd_pins axi_ic_ps7_S_AXI_ACP/S02_ACLK] [get_bd_pins dm_0/m_axi_mm2s_aclk] [get_bd_pins dm_0/s_axi_lite_aclk] [get_bd_pins dm_1/m_axi_mm2s_aclk] [get_bd_pins dm_1/s_axi_lite_aclk] [get_bd_pins dm_2/m_axi_s2mm_aclk] [get_bd_pins dm_2/s_axi_lite_aclk] [get_bd_pins mmult_accel_0/ap_clk] [get_bd_pins mmult_accel_0_if/aclk] [get_bd_pins mmult_accel_0_if/m_axis_aclk] [get_bd_pins mmult_accel_0_if/s_axi_aclk] [get_bd_pins mmult_accel_0_if/s_axis_aclk] [get_bd_pins proc_sys_reset_2_200M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK2] [get_bd_pins ps7/M_AXI_GP0_ACLK] [get_bd_pins ps7/S_AXI_ACP_ACLK]
  connect_bd_net -net ps7_FCLK_CLK3 [get_bd_pins proc_sys_reset_3_166M/slowest_sync_clk] [get_bd_pins ps7/FCLK_CLK3]
  connect_bd_net -net ps7_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0_100M/ext_reset_in] [get_bd_pins proc_sys_reset_1_142M/ext_reset_in] [get_bd_pins proc_sys_reset_2_200M/ext_reset_in] [get_bd_pins proc_sys_reset_3_166M/ext_reset_in] [get_bd_pins ps7/FCLK_RESET0_N]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins ps7/IRQ_F2P] [get_bd_pins xlconcat/dout]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces dm_0/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_ps7_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x400000 -offset 0xE0000000 [get_bd_addr_spaces dm_0/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_IOP] SEG_ps7_ACP_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces dm_0/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_M_AXI_GP0] SEG_ps7_ACP_M_AXI_GP0
  create_bd_addr_seg -range 0x1000000 -offset 0xFC000000 [get_bd_addr_spaces dm_0/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_QSPI_LINEAR] SEG_ps7_ACP_QSPI_LINEAR
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces dm_1/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_ps7_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x400000 -offset 0xE0000000 [get_bd_addr_spaces dm_1/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_IOP] SEG_ps7_ACP_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces dm_1/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_M_AXI_GP0] SEG_ps7_ACP_M_AXI_GP0
  create_bd_addr_seg -range 0x1000000 -offset 0xFC000000 [get_bd_addr_spaces dm_1/Data_MM2S] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_QSPI_LINEAR] SEG_ps7_ACP_QSPI_LINEAR
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces dm_2/Data_S2MM] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_ps7_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x400000 -offset 0xE0000000 [get_bd_addr_spaces dm_2/Data_S2MM] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_IOP] SEG_ps7_ACP_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces dm_2/Data_S2MM] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_M_AXI_GP0] SEG_ps7_ACP_M_AXI_GP0
  create_bd_addr_seg -range 0x1000000 -offset 0xFC000000 [get_bd_addr_spaces dm_2/Data_S2MM] [get_bd_addr_segs ps7/S_AXI_ACP/ACP_QSPI_LINEAR] SEG_ps7_ACP_QSPI_LINEAR
  create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs dm_0/S_AXI_LITE/Reg] SEG_dm_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x40410000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs dm_1/S_AXI_LITE/Reg] SEG_dm_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x40420000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs dm_2/S_AXI_LITE/Reg] SEG_dm_2_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs mmult_accel_0_if/S_AXI/Reg] SEG_mmult_accel_0_if_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 330 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 350 -defaultsOSRD
preplace inst proc_sys_reset_2_200M -pg 1 -lvl 3 -y 440 -defaultsOSRD
preplace inst ps7 -pg 1 -lvl 2 -y 420 -defaultsOSRD
preplace inst proc_sys_reset_0_100M -pg 1 -lvl 3 -y 80 -defaultsOSRD
preplace inst xlconcat -pg 1 -lvl 1 -y 410 -defaultsOSRD
preplace inst proc_sys_reset_1_142M -pg 1 -lvl 3 -y 240 -defaultsOSRD
preplace inst proc_sys_reset_3_166M -pg 1 -lvl 3 -y 600 -defaultsOSRD
preplace netloc ps7_FIXED_IO 1 2 2 NJ 350 NJ
preplace netloc ps7_FCLK_CLK0 1 2 1 540
preplace netloc ps7_FCLK_CLK1 1 2 1 550
preplace netloc ps7_DDR 1 2 2 NJ 330 NJ
preplace netloc xlconcat_0_dout 1 1 1 N
preplace netloc ps7_FCLK_CLK2 1 2 1 570
preplace netloc ps7_FCLK_CLK3 1 2 1 540
preplace netloc ps7_FCLK_RESET0_N 1 2 1 560
levelinfo -pg 1 0 90 360 720 890 -top 0 -bot 690
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


