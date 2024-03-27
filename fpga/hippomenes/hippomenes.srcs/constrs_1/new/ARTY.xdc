## This file is for the ARTY
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal 100 MHz

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports sysclk]

# do not time async inputs
set_false_path -from [get_ports sw0]
set_false_path -from [get_ports sw1]

set_false_path -to [get_ports led0]
set_false_path -to [get_ports led1]
set_false_path -to [get_ports led2]
set_false_path -to [get_ports led3]

# set_false_path -to [get_ports rx]

#set_false_path -to [get_ports led_r0]
#set_false_path -to [get_ports led_r1]
#set_false_path -to [get_ports led_r2]
#set_false_path -to [get_ports led_r3]

#set_false_path -to [get_ports led_g0]
#set_false_path -to [get_ports led_g1]
#set_false_path -to [get_ports led_g2]
#set_false_path -to [get_ports led_g3]

#set_false_path -to [get_ports led_b0]
#set_false_path -to [get_ports led_b1]
#set_false_path -to [get_ports led_b2]
#set_false_path -to [get_ports led_b3]

##Switches
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports sw0]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports sw1]

## TX_IN
# set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports rx]

##LEDs
#set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports led_r0]
#set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports led_r1]
#set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports led_r2]
#set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports led_r3]

#set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports led_g0]
#set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports led_g1]
#set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports led_g2]
#set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports led_g3]

#set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports led_b0]
#set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports led_b1]
#set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports led_b2]
#set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports led_b3]

set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports led0]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports led1]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports led2]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports led3]


