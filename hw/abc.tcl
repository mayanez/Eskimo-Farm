set vga_led 0x0
puts "Started system-console-test-script"
# Using the JTAG chain, check the clock and reset"
set j [lindex [get_service_paths jtag_debug] 0]
open_service jtag_debug $j
puts "Opened jtag_debug"
puts "Checking the JTAG chain loopback: [jtag_debug_loop $j {1 2 3 4 5 6}]"
jtag_debug_reset_system $j
puts -nonewline "Sampling the clock: "
foreach i {1 1 1 1 1 1 1 1 1 1 1 1} {
puts -nonewline [jtag_debug_sample_clock $j]
}
puts ""
puts "Checking reset state: [jtag_debug_sample_reset $j]"
close_service jtag_debug $j
puts "Closed jtag_debug"
# Perform bus reads and writes
set m [lindex [get_service_paths master] 0]
open_service master $m
puts "Opened master"

master_write_32 $m [expr $vga_led ] 0x40209103

close_service master $m
puts "Closed master"
