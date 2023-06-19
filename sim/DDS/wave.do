onerror {resume}
radix define wave {
    "3'b000" "SINE",
    "3'b001" "COSINE",
    "3'B010" "SQUARE",
    "3'B011" "SAW",
    "3'B100" "ASK",
    "3'B101" "BPSK",
    "3'B110" "FSK",
    "3'B111" "QPSK",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_DDS/DUT/rst
add wave -noupdate /tb_DDS/DUT/en
add wave -noupdate /tb_DDS/DUT/data
add wave -noupdate /tb_DDS/DUT/mode
add wave -noupdate -format Analog-Step -height 74 -max 4096.0 -min -4096.0 /tb_DDS/DUT/wave
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26500 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 76
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
configure wave -timelineunits ns
update
WaveRestoreZoom {19420 ns} {41100 ns}
