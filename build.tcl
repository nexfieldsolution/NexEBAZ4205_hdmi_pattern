# =============================================================
# build.tcl - Synthesis + Implementation + Bitstream
# =============================================================
open_project ./project_1/project_1.xpr

# UART 소스 추가 (없으면 추가, 있으면 무시)
set uart_files {
    ./project_1/project_1.srcs/sources_1/imports/pattern/HDL/UART_TX_CTRL.vhd
    ./project_1/project_1.srcs/sources_1/imports/pattern/HDL/uart_hello.v
}
foreach f $uart_files {
    if {[lsearch [get_files] [file normalize $f]] < 0} {
        add_files -fileset sources_1 $f
    }
}

reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "Synthesis failed"
}

reset_run impl_1
launch_runs impl_1 -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    error "Implementation failed"
}

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

puts ""
puts "빌드 완료: project_1/project_1.runs/impl_1/pattern_hdmi.bit"
puts ""
