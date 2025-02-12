proc write_mem_info_int {filename args} {
	if {[string length $args] != 0 && $args != "debug"} {
		puts "Unknown arg $args. Supported arg is debug"
	} else {
		if {$args == "debug"} {
			puts "Debug Mode Enabled"
		}
		design_check
		set fileout [open $filename "w"]
		set processors [find_processor]
		if {$args == "debug"} {
			if {[llength $processors] == 0} {
				puts "Error: No Processors found. 
			} else {
				puts "Success: Processors: $processors"
			}
		}
		if {[llength $processors] != 0} {		
			puts $fileout "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
			puts $fileout "<MemInfo Version=\"1\" Minor=\"1\">"
			for {set p 0} {$p < [llength $processors]} {incr p} {
				puts $fileout "  <Processor Endianness=\"[get_endianness [lindex $processors $p]]\" InstPath=\"[lindex $processors $p]\">"
				set controllers [get_controllers [lindex $processors $p]]
				if {$args == "debug"} {
					if {[llength $controllers] == 0} {
						puts "Error: No Controllers found. 
					} else {
						puts "Success: Controllers: $controllers"
					}
				}
				set processor [lindex $processors $p]
				for {set c 0} {$c < [llength $controllers]} {incr c} {
					if {$args == "debug"} {
						if {[llength [associated_bram [lindex $controllers $c]]] == 0} {
							puts "Error: No BRAM Block associated with [lindex $controllers $c]."
						} else {
							puts "Success: BRAM Block associated with [lindex $controllers $c] found"
						}
					} 
					set cell_name_bram [order_bmm [associated_bram [lindex $controllers $c]]]
					set bram [llength $cell_name_bram]
					if {$args == "debug"} {
						if {[llength $bram] == 0} {
							puts "Error: Cant find BRAM for [associated_bram [lindex $controllers $c]]"
						} else {
							puts "Success: BRAM for [associated_bram [lindex $controllers $c]] found"
						}
					}
					set bram_range [get_range $cell_name_bram]
					#set bram_range [expr {[expr {$bram * [expr {[expr {32 * 1024}] /8}]}] -1}]
					set base_addr [hex2dec [format 0x%.8x [get_base_addr [lindex $controllers $c]]]]
					set high_addr [hex2dec [format 0x%.8x [expr {$base_addr + $bram_range}]]]
					puts $fileout "    <AddressSpace Name=\"[swap $processor.[lindex $controllers $c]]\" Begin=\"$base_addr\" End=\"$high_addr\">"
					
					if {$bram >= 32} {
						set sequence "7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,23,22,21,20,19,18,17,16,31,30,29,28,27,26,25,24"
						set bus_blocks [expr {$bram / 32}]
					} elseif {$bram >= 16 && $bram < 32} {
						set sequence "7,5,3,1,15,13,11,9,23,21,19,17,31,29,27,25"
						set bus_blocks 1
					} elseif {$bram >= 8 && $bram < 16} {
						set sequence "7,3,15,11,23,19,31,27"
						set bus_blocks 1
					} elseif {$bram >= 4 && $bram < 8} {
						set sequence "7,15,23,31"
						set bus_blocks 1
					} else {
					set sequence "15,31"
					set bus_blocks 1
					}
					set sequence [split $sequence ","]
					for {set b 0} {$b < $bus_blocks} {incr b} {
						puts $fileout "      <BusBlock>"
						for {set i 0} {$i < [llength $sequence]} {incr i} {
							for {set j 0} {$j < [llength $cell_name_bram]} {incr j} {
								set block_start [expr {32768 * $b}]
								set bmm_width [bram_info [lindex $cell_name_bram $j] "bit_lane"]
								set bmm_width [split $bmm_width ":"]
								set bmm_msb [lindex $bmm_width 0]
								set bmm_lsb [lindex $bmm_width 1]
								set bmm_range [bram_info [lindex $cell_name_bram $j] "range"]
								set split_ranges [split $bmm_range ":"]
								set MSB [lindex $sequence $i]
								if {$MSB == $bmm_msb && $block_start == [lindex $split_ranges 0]} {
									set bram_type [get_property REF_NAME [get_cells [lindex $cell_name_bram $j]]]
									set status [get_property STATUS [get_cells [lindex $cell_name_bram $j]]]
																								
									if {$status == "UNPLACED"} {
										set placed "X0Y0"
									} else {
										set placed [get_property LOC [get_cells [lindex $cell_name_bram $j]]]
										set placed_list [split $placed "_"]
										set placed [lindex $placed_list 1]
									}
									set bram_type [get_property REF_NAME [get_cells [lindex $cell_name_bram $j]]]			
									if {$bram_type == "RAMB36E1" || $bram_type == "RAMB36E2"} {
										set bram_type "RAMB36"
									}
																
									puts $fileout "        <BitLane MemType=\"$bram_type\" Placement=\"$placed\">"
									puts $fileout "          <DataWidth MSB=\"$bmm_msb\" LSB=\"$bmm_lsb\"/>"
									puts $fileout "          <AddressRange Begin=\"[lindex $split_ranges 0]\" End=\"[lindex $split_ranges 1]\"/>"
									puts $fileout "          <Parity ON=\"false\" NumBits=\"0\"/>"
									puts $fileout "        </BitLane>"
								}
							}
						}
						puts $fileout "      </BusBlock>"
					}
					puts $fileout "    </AddressSpace>"
				}
		
	
				puts $fileout "  </Processor>"
			}
	
			puts $fileout "  <Config>"
			puts $fileout "    <Option Name=\"Part\" Val=\"[get_property PART [current_project ]]\"/>"
			puts $fileout "  </Config>"
			puts $fileout "</MemInfo>"
		}
		close $fileout	
		puts [glob -directory [pwd] type -f $filename]
	
		set proc_list "" 
		set data_list ""
		for {set i 0} {$i < [llength $processors]} {incr i} {
			set data_list "$data_list -data <ELF/MEM File>.elf/.mem"
			set proc_list "$proc_list -proc [lindex $processors $i]" 
		}
		puts "MMI file is created. The updatemem command template below can be used to populate the BRAM:"
		puts "updatemem -force -debug -meminfo $filename $data_list $proc_list -bit [get_bit_file] -out download.bit > dump.txt"
	}
}

proc get_bit_file {} {
	set project [get_projects]
	set runs [get_runs]
	set current_run [lindex $runs [expr {[llength $runs] - 1}]]
	set impl [string range $current_run [string first "impl" $current_run] [expr {[string length $current_run] - 1}]]
	set bit [glob -nocomplain -type f -directory ${project}.runs/$impl *.bit]
	if {$bit == ""} {
		puts "Cant find bit file at ${project}.runs/$impl"
		puts "Have you run write_bitstream?"
		return "<BIT FILE>.bit"
	} else {
		return [glob -nocomplain -type f -directory ${project}.runs/$impl *.bit]
	}
}

proc swap {string} {
	return [string map {/ _} $string]
}

proc design_check {} {
	if {[get_designs] == ""} {
		puts "Warning: This script needs to be ran on an Implemented Design"
		puts "Open an Implmented design and re-run the write_mem_info <file name>.mmi command"
	}
}

proc associated_bram {bram_cntrl} {
	set temp_net [get_nets -of_objects [get_cells $bram_cntrl]]
	set associated_bram ""
	set root [split $bram_cntrl "/"]
	set root [lindex $root 0]
	set periph [get_design_ip $root]
	for {set i 0} {$i < [llength $periph]} {incr i} {
		set ip_type [get_parameter [lindex $periph $i]]
		if {[regexp -nocase {blk_mem_gen} $ip_type] == 1} {
			set bram_nets [get_nets -of_objects [lindex $periph $i]]
			for {set j 0} {$j < [llength $bram_nets]} {incr j} {
				for {set x 0} {$x < [llength $temp_net]} {incr x} {
					if {[lindex $bram_nets $j] == [lindex $temp_net $x]} {
						return [lindex $periph $i]
					}
				}
			}
		}
	}
}

proc get_base_addr {controller} {
	set addr_space [get_property BMM_INFO_ADDRESS_SPACE [get_cells $controller]]
	set addr_space [split $addr_space " "]
	return [lindex $addr_space 2] 
}

proc bmm_processor_info {processor} {
	set info [get_property bmm_info_processor [get_cells $processor]]
	set info [split $info " "]
	return $info
}

proc get_endianness {processor} {
	set endian [bmm_processor_info $processor]
	set endian [split $endian " "]
	set endian [lindex $endian 0]
	if {$endian == "microblaze-le"} {
		return "Little"
	} else {
		return "Big"
	}
}

proc bram_info {bram type} {
	set temp [get_property bmm_info_memory_device [get_cells $bram]]
	set bmm_info_memory_device [regexp {\[(.+)\]\[(.+)\]} $temp all 1 2]
	if {$type == "bit_lane"} {
		return $1
	} elseif {$type == "range"} {
		return $2
	} else {
		return $all
	}
}

proc get_controllers {processor} {
	set controllers [bmm_processor_info $processor]
	set bram_cntlr_temp ""
	set bram_cntlr ""
	set parent [get_property PARENT [get_cells $processor]]
	for {set i 2} {$i < [llength $controllers]} {incr i} {
		lappend bram_cntlr_temp [lindex $controllers $i]
	}
	for {set i 0} {$i < [llength $bram_cntlr_temp]} {incr i} {
		
		lappend bram_cntlr "${parent}/[lindex $bram_cntlr_temp $i+1]" 
		set i [expr {$i + 1}]
	}
	return $bram_cntlr
}

proc get_parameter {ip} {
	set info [get_property x_core_info [get_cells $ip]]
	set vars [split $info ","]
	return [lindex $vars 0]	
}

proc get_design_ip {design} {
	set design_ip ""
	set periph [get_cells -hierarchical *]
	for {set i 0} {$i < [llength $periph]} {incr i} {
		set root [split [lindex $periph $i] "/"]
		set root [lindex $root 0]
		set is_ip [get_property x_core_info [lindex $periph $i]]
		if {$root == $design && [string length $is_ip] != 0} {
			lappend design_ip [lindex $periph $i]
		}
	}
	return $design_ip
}

proc find_processor {} {
	set processors ""
	set perph [get_cells -hierarchical *]
	for {set i 0} {$i < [llength $perph]} {incr i} {
		set info [get_parameter [lindex $perph $i]]
		if {$info == "MicroBlaze"} {
			lappend processors [get_property NAME [get_cells [lindex $perph $i]]]
		} 
	}
	return $processors
}

proc get_range {brams} {
	set bram_range 0
	for {set r 0} {$r < [llength $brams]} {incr r} {
		set temp [get_property bmm_info_memory_device [get_cells [lindex $brams $r]]]
		set bmm_info_memory_device [regexp {\[(.+)\]\[(.+)\]} $temp all 1 2]
		set range_arr [split $2 ":"]
		set bram_range [expr {[expr {[expr {[lindex $range_arr 1] - [lindex $range_arr 0]}] + 1}] + $bram_range}]
	}
	return [expr {$bram_range -1}]
}

proc order_bmm {cell} {
	set bram [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ BMEM.bram.* || PRIMITIVE_TYPE =~ BLOCKRAM.BRAM.* } ]
	
	set bram_arr ""
	set bram_arr_ordered ""
	set error 0
		
	for {set i 0} {$i < [llength $bram]} {incr i} {
		set found [string first $cell [lindex $bram $i]]
		if {$found != -1} {
			lappend bram_arr [lindex $bram $i]
		}
	}
	
	#do a sweep to see if BRAM can be re-ordered
	for {set j 0} {$j < [llength $bram_arr]} {incr j} {
		set temp [get_bram_seq [lindex $bram_arr $j]]
		if {$temp == "error"} {
			set error 1
			break;
		}
	}

	
	if {$error == 0} {
		set count [expr {[llength $bram_arr] -1}]
		for { set i $count } { $i >= 0 } { incr i -1 } {
			for {set j 0} {$j < [llength $bram_arr]} {incr j} {
				set temp [get_bram_seq [lindex $bram_arr $j]]
				if {$temp == $i} {
					lappend bram_arr_ordered [lindex $bram_arr $j]
				}
			}
		}
		return $bram_arr_ordered
	} else {
		puts "Cannot Re-Order the BRAM. User will need to do this manually in the BMM file"
		return $bram_arr
	}

	
}

proc get_bram_seq {bram} {
	set bram [get_cells $bram]
	#difficult to catch a "[" in TCL. Will explode string and match
	set str_list [split $bram {}]
	for {set j 0} {$j < [llength $str_list]} {incr j} {
		set found [string match {\[} [lindex $str_list $j]]
		if {$found == 1} {
			set start $j
			break;
		}
	}
	for {set j 0} {$j < [llength $str_list]} {incr j} {
		set found [string match {\]} [lindex $str_list $j]]
			if {$found == 1} {
				set end $j
				break;
			}
		}
	set num [string range $bram [expr {$start + 1}] [expr {$end - 1}]]
	set error [regexp ^[0-9]{1,45}$ $num]
	if {$error == 1} {
		return $num
	} else {
		return "error"
	}

}

proc dec2hex {value} {

   	regsub -all {[^0-9\.\-]} $value {} newtemp
   	set value [string trim $newtemp]
   	if {$value < 2147483647 && $value > -2147483648} {
      		set tempvalue [format "%#010X" [expr $value]]
      		return [string range $tempvalue 2 9]
   	} elseif {$value < -2147483647} {
   	   	return "80000000"
   	} else {
   		return "7FFFFFFF"
   	}
}

proc hex2dec {largeHex} {
    set res 0
    set largeHex [string range $largeHex 2 [expr {[string length $largeHex] - 1}]]
    foreach hexDigit [split $largeHex {}] {
        set new 0x$hexDigit
        set res [expr {16*$res + $new}]
    }
    return $res
}

