# Setting options
set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn) 10
set val(rp) AODV
set val(x) 500
set val(y) 400
set val(stop) 10

# Define simulator
set ns [new Simulator]

# Create nam and trace files
set tracefd [open nirkabel2.tr w]
set namtrace [open nirkabel2.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# Topography setup
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god [create-god $val(nn)]

# Node configuration
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

# Create node objects and set colors (0-2 blue, 3-5 cyan, 6-9 red)
for {set i 0} {$i < 3} {incr i} {
    set node_($i) [$ns node]
    $node_($i) color blue
    $ns at 0.0 "$node_($i) color blue"
}

for {set i 3} {$i < 6} {incr i} {
    set node_($i) [$ns node]
    $node_($i) color black
    $ns at 0.0 "$node_($i) color black"
}

for {set i 6} {$i < 10} {incr i} {
    set node_($i) [$ns node]
    $node_($i) color red
    $ns at 0.0 "$node_($i) color red"
}

# Set initial positions for mobile nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set xx [expr rand()*$val(x)]
    set yy [expr rand()*$val(y)]
    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
}

# Set initial positions in nam
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $node_($i) 30
}

# End simulation
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at $val(stop) "$node_($i) reset"
}

# Dynamic destination procedure
proc destination {} {
    global ns val node_
    set now [$ns now]
    for {set i 0} {$i < $val(nn)} {incr i} {
        set xx [expr rand()*$val(x)]
        set yy [expr rand()*$val(y)]
        $node_($i) setdest $xx $yy 10.0
    }
    $ns at [expr $now + 1.0] "destination"
}

$ns at 0.0 "destination"

# Stop procedure
$ns at $val(stop) "stop"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    exec nam nirkabel2.nam &
}

# Run the simulator
$ns run
