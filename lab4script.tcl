read_vhdl { /home/m/m_dav9/COEN313/Lab_4/lab4new.vhd }
read_xdc lab4new.xdc


synth_design -top registers_min_max  -part xc7a100tcsg324-1

opt_design
place_design
route_design

report_timing_summary

write_bitstream -force lab4.bit

