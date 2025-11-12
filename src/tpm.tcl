# Tcl script to utilize performance monitor
set pwd 2
set ewd 4
set fwd 4
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
proc get_control { base } {
    set ctrl [axiread [format %lx [expr $base + 0]]]
    return 0x$ctrl
}
proc get_comparator { base } {
    set comp [axiread [format %lx [expr $base + 8]]]
    return 0x$comp
}
proc get_filter { base idx } {
    set value [axiread [format %lx [expr $base + 16 * $idx + 16]]]
    set mask  [axiread [format %lx [expr $base + 16 * $idx + 24]]]
    return 0x$value,0x$mask
}
proc get_all { base } {
    for { set i 0 } { $i < $::pwd } { incr i } {
        puts "Port $i:"
        puts "    Control:    [get_control    [expr $base + $i * 0x10000]]"
        puts "    Comparator: [get_comparator [expr $base + $i * 0x10000]]"
        for { set j 0 } { $j < $::fwd } { incr j } {
            puts "    Filter $j:  [get_filter [expr $base + $i * 0x10000] $j]"
        }
    }
}
proc set_control { base mask remain } {
    set ctrl [format %016lx [expr ($mask << 32) | ($remain << 16) | 1]]
    axiwrite [format %lx [expr $base + 0]] $ctrl
}
proc set_comparator { base comp } {
    axiwrite [format %lx [expr $base + 8]] [format %016lx $comp]
}
proc set_filter { base idx value mask } {
    axiwrite [format %lx [expr $base + 16 * $idx + 16]] [format %016lx $value]
    axiwrite [format %lx [expr $base + 16 * $idx + 24]] [format %016lx $mask]
}
proc get_sample { base } {
    set ctrl 0x[axiread [format %lx [expr $base + 0]]]
    if { ![expr $ctrl & 1] } { return }
    if { [expr $ctrl & 2] } { puts "Warning: half capacity of buffer reached." }
    set tag  [axiread [format %lx [expr $base + 0x2008]]]
    set info [axiread [format %lx [expr $base + 0x2010]]]
    set sample 0x$tag,0x$info
    for { set i 0 } { $i < $::ewd } { incr i } {
        if {$i == 0} { append sample ":" } else { append sample "," }
        append sample 0x[axiread [format %lx [expr $base + 0x1000 + 8 * $i]]]
    }
    axiwrite [format %lx [expr $base + 0]] [format %016lx [expr $ctrl & ~1]]
    return $sample
}
proc get_remain { base remain } {
    set ctrl   [get_control $base]
    set mask   [expr ($ctrl >> 32) & 0xFFFFFFFF]
    set_control $base $mask $remain
    set sample 0x[axiread [format %lx [expr $base + 0x2000]]]
    for { set i 0 } { $i < $::ewd } { incr i } {
        if {$i == 0} { append sample ":" } else { append sample "," }
        append sample 0x[axiread [format %lx [expr $base + 0x3000 + 8 * $i]]]
    }
    return $sample
}
proc clear_buffer { base } {
    while { [get_sample $base] != "" } {}
}
proc auto_sample { base filename } {
    set num 0
    while { 1 } {
        for { set i 0 } { $i < $::pwd } { incr i } {
            set sample [get_sample [expr $base + $i * 0x10000]]
            if { [string length $sample] > 0 } {
                set num [expr $num + 1]
                puts "Sample $num triggered."
                set file [open $filename a]
                puts $file $sample
                close $file
            }
        }
    }
}
