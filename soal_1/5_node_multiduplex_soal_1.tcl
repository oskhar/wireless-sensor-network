# Create a simulator object
set ns [new Simulator]

# Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Green

# Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# Define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    # Close the NAM trace file
    close $nf
    # Execute NAM on the trace file
    exec nam out.nam &
    exit 0
}

# Create seven nodes
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node] ;# New node
set n7 [$ns node] ;# New node

# Create links between the nodes
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n5 1.7Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 1.7Mb 10ms DropTail

# New links for the additional nodes
$ns duplex-link $n5 $n6 1.5Mb 15ms DropTail ;# Link between n5 and n6
$ns duplex-link $n6 $n7 1.5Mb 15ms DropTail ;# Link between n6 and n7

# Set Queue Size of link (n3-n5) and (n4-n5) to 10
$ns queue-limit $n3 $n5 10
$ns queue-limit $n4 $n5 10

# Give node position (for NAM)
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n5 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n4 $n5 orient right
$ns duplex-link-op $n5 $n6 orient right-down ;# New link
$ns duplex-link-op $n6 $n7 orient right ;# New link

# Monitor the queue for link (n3-n5). (for NAM)
$ns duplex-link-op $n3 $n5 queuePos 0.5

# Setup a TCP connection
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n3 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n5 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 1

# New TCP connection for new nodes
set tcp3 [new Agent/TCP]
$tcp3 set class_ 2
$ns attach-agent $n6 $tcp3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n7 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 1

# Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

# New FTP over TCP for new nodes
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ftp3 set type_ FTP

# Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2

# Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

# Schedule events for the CBR and FTP agents
$ns at 0.1 "$cbr start"
$ns at 0.8 "$ftp start"
$ns at 1.0 "$ftp2 start"
$ns at 1.2 "$ftp3 start" ;# Start new FTP
$ns at 3.8 "$ftp stop"
$ns at 4.0 "$ftp2 stop"
$ns at 4.2 "$ftp3 stop" ;# Stop new FTP
$ns at 4.5 "$cbr stop"

# Detach tcp and sink agents (not really necessary)
$ns at 4.5 "$ns detach-agent $n1 $tcp ; $ns detach-agent $n3 $sink"

# Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

# Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

# Run the simulation
$ns run
