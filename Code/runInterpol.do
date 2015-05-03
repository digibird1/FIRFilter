vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/myFilter_pkg.vhd
vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/Filter.vhd
vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/SignalFromLookUp.vhd
vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/Interpolation.vhd
vcom -reportprogress 300 -work work /home/imp/electronics/FPGA/FPGAProjects/FilterTest/simulation/modelsim/Interpolation.vht
vsim -novopt work.interpolation_vhd_tst
do waveInterpolation.do
restart -f
run -all
