# Setting options
set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn) 8
set val(rp) AODV
set val(x) 500
set val(y) 400
set val(stop) 10

# Initialize simulator
set ns [new Simulator]

# Create trace and nam files
set tracefd [open Graph2.tr w]
set namtrace [open Graph2.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# Set up topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]

# Configure nodes
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channelType $val(chan) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace ON

# Create nodes and Color nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
    $node_($i) color black
    $ns at 0.0 "$node_($i) color black"
}

# Set initial positions for all nodes
$node_(0) set X_ 50.0
$node_(0) set Y_ 50.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 200.0
$node_(1) set Y_ 250.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 300.0
$node_(2) set Y_ 300.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 100.0
$node_(3) set Y_ 200.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 250.0
$node_(4) set Y_ 150.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 150.0
$node_(5) set Y_ 350.0
$node_(5) set Z_ 0.0

$node_(6) set X_ 400.0
$node_(6) set Y_ 200.0
$node_(6) set Z_ 0.0

$node_(7) set X_ 350.0
$node_(7) set Y_ 100.0
$node_(7) set Z_ 0.0

# Set initial positions for NAM
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $node_($i) 30
}

# Set when to end nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at $val(stop) "$node_($i) reset"
}

# End nam and simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 10.01 "puts \"end simulation\"; $ns halt"

# Graph procedure
$ns at 1.0 "Graph"
set g [open graph.tr w]
set g1 [open graph1.tr w]
proc Graph {} {
    global ns g g1
    set time 1.0
    set now [$ns now]
    puts $g "[expr rand()*8] [expr rand()*6]"
    puts $g1 "[expr rand()*8] [expr rand()*6]"
    $ns at [expr $now+$time] "Graph"
}

# Stop procedure
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    exec xgraph -P -bb -geometry 700x800 graph.tr graph1.tr &
    exec nam Graph2.nam &
    exit 0
}

# Run the simulation
$ns run
