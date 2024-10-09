# Membuat instace simulator baru
set ns [new Simulator]

set tr [open "out.tr" w]
$ns trace-all $tr

set namfile [open "out.nam" w]
$ns namtrace-all $namfile

# Inisiasi warna ns
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Yellow

# Define a 'finish' procedure
proc finish {} {
    global ns tr namfile
    $ns flush-trace
    close $tr
    close $namfile
    exec nam out.nam &
    exit 0
}

# Inisiasi 10 node
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]

# Mengatur duplex link antara node-node
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n8 2Mb 10ms DropTail
$ns duplex-link $n1 $n6 2Mb 10ms DropTail
$ns duplex-link $n6 $n7 2Mb 10ms DropTail
$ns duplex-link $n7 $n8 2Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n5 $n9 2Mb 10ms DropTail
$ns duplex-link $n9 $n10 2Mb 10ms DropTail

# Mengatur orientasi link untuk visualisasi NAM
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n8 orient right-down
$ns duplex-link-op $n1 $n6 orient right
$ns duplex-link-op $n6 $n7 orient right
$ns duplex-link-op $n7 $n8 orient right
$ns duplex-link-op $n1 $n4 orient right-down
$ns duplex-link-op $n4 $n5 orient right
$ns duplex-link-op $n5 $n9 orient right-up
$ns duplex-link-op $n9 $n10 orient right

# Mengatur koneksi TCP
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n10 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

# Mengatur FTP pada koneksi TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

# Mengatur koneksi UDP
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null
$udp set fid_ 2

set udpa [new Agent/UDP]
$ns attach-agent $n3 $udpa
set null [new Agent/Null]
$ns attach-agent $n8 $null
$ns connect $udpa $null
$udpa set fid_ 3

set udpb [new Agent/UDP]
$ns attach-agent $n5 $udpb
set null [new Agent/Null]
$ns attach-agent $n9 $null
$ns connect $udpb $null
$udpb set fid_ 4

set udpc [new Agent/UDP]
$ns attach-agent $n6 $udpc
set null [new Agent/Null]
$ns attach-agent $n7 $null
$ns connect $udpc $null
$udpc set fid_ 5

# Mengatur CBR pada koneksi UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

set cbra [new Application/Traffic/CBR]
$cbra attach-agent $udpa
$cbra set type_ CBR
$cbra set packet_size_ 1000
$cbra set rate_ 1mb
$cbra set random_ false

set cbrb [new Application/Traffic/CBR]
$cbrb attach-agent $udpb
$cbrb set type_ CBR
$cbrb set packet_size_ 1000
$cbrb set rate_ 1mb
$cbrb set random_ false

set cbrc [new Application/Traffic/CBR]
$cbrc attach-agent $udpc
$cbrc set type_ CBR
$cbrc set packet_size_ 1000
$cbrc set rate_ 1mb
$cbrc set random_ false

# Schedule events for the CBR and FTP agent
$ns at 0.1 "$cbr start"
$ns at 0.5 "$cbra start"
$ns at 0.5 "$cbrb start"
$ns at 0.5 "$cbrc start"
$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"
$ns at 4.5 "$cbra stop"
$ns at 4.5 "$cbrb stop"
$ns at 4.5 "$cbrc stop"
$ns at 5.0 "finish"

puts "CBR packet size = {$cbr set packet_size_}"
puts "CBR interval = {$cbr set interval_}"

$ns run
