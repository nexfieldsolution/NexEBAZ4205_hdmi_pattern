# =============================================================
# program.tcl - EBAZ4205 JTAG programming
# =============================================================
open_hw_manager
connect_hw_server -allow_non_jtag

open_hw_target

puts "감지된 장치 목록: [get_hw_devices]"
set device ""
foreach d [get_hw_devices] {
    if {[string match "xc7z*" $d]} {
        set device $d
        break
    }
}
if {$device == ""} {
    error "Zynq PL 장치를 찾을 수 없습니다. 연결된 장치: [get_hw_devices]"
}
puts "사용 장치: $device"
current_hw_device $device
refresh_hw_device $device

set_property PROGRAM.FILE {project_1/project_1.runs/impl_1/pattern_hdmi.bit} $device
program_hw_devices $device

puts ""
puts "프로그래밍 완료"
puts ""
