# Tcl script to utilize performance monitor
set tpmbase 0
set evnum 12
proc axiwrite { address value } {
    create_hw_axi_txn -force txn [get_hw_axis hw_axi_1] -address $address -data $value -len 1 -type write
    run_hw_axi -quiet txn
    delete_hw_axi_txn txn
}
proc axiread { address } {
    create_hw_axi_txn -force txn [get_hw_axis hw_axi_1] -address $address -len 1 -type read
    run_hw_axi -quiet txn
    set ret [get_property DATA [get_hw_axi_txn txn]]
    delete_hw_axi_txn txn
    return $ret
}
proc get_control {} {
    set ctrl [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 2)]]]
    return 0x$ctrl
}
proc get_comparator {} {
    set comp [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 3)]]]
    return 0x$comp
}
proc get_floor {} {
    set l [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 4)]]]
    set h [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 5)]]]
    return 0x$h$l
}
proc get_ceiling {} {
    set l [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 6)]]]
    set h [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 7)]]]
    return 0x$h$l
}
proc get_mask {} {
    set l [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 8)]]]
    set h [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 9)]]]
    return 0x$h$l
}
proc set_selection { sel } {
    set ctrl [format %016lx [expr ($sel << 8) | 1]]
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 2)]] $ctrl
}
proc set_comparator { comp } {
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 3)]] [format %016lx $comp]
}
proc set_floor { high low } {
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 4)]] [format %016lx $low]
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 5)]] [format %016lx $high]
}
proc set_ceiling { high low } {
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 6)]] [format %016lx $low]
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 7)]] [format %016lx $high]
}
proc set_mask { high low } {
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 8)]] [format %016lx $low]
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 9)]] [format %016lx $high]
}
proc get_sample {} {
    set ctrl 0x[axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 2)]]]
    if { ![expr $ctrl & 1] } { return }
    if { [expr $ctrl & 2] } { puts "Warning: half capacity of buffer reached." }
    set tagl [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 0)]]]
    set tagh [axiread [format %lx [expr $::tpmbase + 8 * ($::evnum + 1)]]]
    set sample 0x[string cat $tagh $tagl]
    for { set i 0 } { $i < $::evnum } { incr i } {
        if {$i == 0} { append sample ":" } else { append sample "," }
        append sample 0x[axiread [format %lx [expr $::tpmbase + 8 * $i]]]
    }
    set ctrl [format %016lx [expr $ctrl & ~1]]
    axiwrite [format %lx [expr $::tpmbase + 8 * ($::evnum + 2)]] $ctrl
    return $sample
}
proc get_all {} {
    puts "Control:    [get_control]"
    puts "Comparator: [get_comparator]"
    puts "Floor:      [get_floor]"
    puts "Ceiling:    [get_ceiling]"
    puts "Mask:       [get_mask]"
}
proc force_sample {} {
    set floor [get_floor]
    set ceil [get_ceiling]
    set comp [get_comparator]
    set mask [get_mask]
    set_floor -1 -1
    set_ceiling 0 0
    set_mask 0 0
    set_comparator 0
    set_comparator $comp
    set_mask 0x[string range $mask 2 17] 0x[string range $mask 18 33]
    set_floor 0x[string range $floor 2 17] 0x[string range $floor 18 33]
    set_ceiling 0x[string range $ceil 2 17] 0x[string range $ceil 18 33]
}
proc clear_buffer {} {
    while { [get_sample] != "" } {}
}
proc auto_sample { filename } {
    set num 0
    while { 1 } {
        set sample [get_sample]
        if { [string length $sample] > 0 } {
            set num [expr $num + 1]
            puts "Sample $num triggered."
            set file [open $filename a]
            puts $file $sample
            close $file
        }
    }
}
