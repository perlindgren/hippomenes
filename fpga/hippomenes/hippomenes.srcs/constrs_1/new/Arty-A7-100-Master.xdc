## Clock signal 100 MHz
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports sysclk]

# do not time async inputs

set_false_path -from [get_ports sw0]
set_false_path -from [get_ports sw1]
set_false_path -to [get_ports led0]
set_false_path -to [get_ports led1]
set_false_path -to [get_ports led2]
set_false_path -to [get_ports led3]
set_false_path -to [get_ports uarttx]

##Switches

set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports sw0]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports sw1]

##LEDs

set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports led0]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports led1]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports led2]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports led3]

##UART
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports uarttx]

