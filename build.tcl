# =============================================================
# build.tcl - Synthesis + Implementation + Bitstream
# =============================================================
open_project ./project_1/project_1.xpr

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
