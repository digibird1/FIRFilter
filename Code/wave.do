onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /filter_vhd_tst/clk
add wave -noupdate /filter_vhd_tst/reset
add wave -noupdate /filter_vhd_tst/signal_in_int
add wave -noupdate /filter_vhd_tst/signal_out_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {71 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {577500 ps}
