vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/Filter.vhd
vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/SignalFromLookUp.vhd
vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/simulation/modelsim/Filter.vht
vsim -novopt work.filter_vhd_tst
do wave.do
restart -f
run -all
