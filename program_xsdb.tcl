# program_xsdb.tcl - PS initialization + PL bitstream loading
connect

# 1. Reset System
targets -set -filter {name =~ "APU*"}
rst -system
after 3000

# 2. PS Initialization (using proven init script)
targets -set -filter {name =~ "*Cortex-A9 MPCore #0*"}
source ps7_init.tcl
ps7_init
ps7_post_config

# 3. Load PL Bitstream
puts "Loading Bitstream: project_1/project_1.runs/impl_1/pattern_hdmi.bit"
fpga /WORK/FPGA/Xilinx/NexEBAZ4205_hdmi_pattern/project_1/project_1.runs/impl_1/pattern_hdmi.bit

puts "Programming Complete with PS Initialization"
exit
