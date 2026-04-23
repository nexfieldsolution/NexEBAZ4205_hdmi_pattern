# xc7z010 → xc7z020으로 파트 변경 후 비트스트림 빌드
open_project project_1.xpr
set_property part xc7z020clg400-1 [current_project]
reset_run synth_1
reset_run impl_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
puts ""
puts "완료: project_1.runs/impl_1/pattern_hdmi.bit"
puts ""
