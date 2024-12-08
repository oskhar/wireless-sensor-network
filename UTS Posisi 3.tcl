# Membuat instance simulator baru
set ns [new Simulator]

# Membuka file trace dan file nam
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

# Membuat 10 node dengan pola lingkaran
set n0 [$ns node]
$n0 set X_ 150.0
$n0 set Y_ 100.0

set n1 [$ns node]
$n1 set X_ 200.0
$n1 set Y_ 150.0

set n2 [$ns node]
$n2 set X_ 250.0
$n2 set Y_ 100.0

set n3 [$ns node]
$n3 set X_ 300.0
$n3 set Y_ 150.0

set n4 [$ns node]
$n4 set X_ 350.0
$n4 set Y_ 100.0

set n5 [$ns node]
$n5 set X_ 300.0
$n5 set Y_ 50.0

set n6 [$ns node]
$n6 set X_ 250.0
$n6 set Y_ 0.0

set n7 [$ns node]
$n7 set X_ 200.0
$n7 set Y_ 50.0

set n8 [$ns node]
$n8 set X_ 100.0
$n8 set Y_ 50.0

set n9 [$ns node]
$n9 set X_ 50.0
$n9 set Y_ 100.0

# Menghubungkan node dengan link duplex mengikuti pola lingkaran
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n4 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n5 $n6 2Mb 10ms DropTail
$ns duplex-link $n6 $n7 2Mb 10ms DropTail
$ns duplex-link $n7 $n8 2Mb 10ms DropTail
$ns duplex-link $n8 $n9 2Mb 10ms DropTail
$ns duplex-link $n9 $n0 2Mb 10ms DropTail

# Menambahkan beberapa link tambahan untuk konektivitas ekstra
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n3 $n5 2Mb 10ms DropTail
$ns duplex-link $n6 $n8 2Mb 10ms DropTail

# Orientasi link untuk visualisasi yang lebih baik di NAM
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n3 $n4 orient right-down
$ns duplex-link-op $n4 $n5 orient down
$ns duplex-link-op $n5 $n6 orient left-down
$ns duplex-link-op $n6 $n7 orient left
$ns duplex-link-op $n7 $n8 orient left-up
$ns duplex-link-op $n8 $n9 orient up
$ns duplex-link-op $n9 $n0 orient right

# Menambahkan agen UDP dan Null di setiap node
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n2 $null1
$ns connect $udp1 $null1

set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n3 $null2
$ns connect $udp2 $null2

set udp3 [new Agent/UDP]
$ns attach-agent $n3 $udp3
set null3 [new Agent/Null]
$ns attach-agent $n4 $null3
$ns connect $udp3 $null3

set udp4 [new Agent/UDP]
$ns attach-agent $n4 $udp4
set null4 [new Agent/Null]
$ns attach-agent $n5 $null4
$ns connect $udp4 $null4

set udp5 [new Agent/UDP]
$ns attach-agent $n5 $udp5
set null5 [new Agent/Null]
$ns attach-agent $n6 $null5
$ns connect $udp5 $null5

set udp6 [new Agent/UDP]
$ns attach-agent $n6 $udp6
set null6 [new Agent/Null]
$ns attach-agent $n7 $null6
$ns connect $udp6 $null6

set udp7 [new Agent/UDP]
$ns attach-agent $n7 $udp7
set null7 [new Agent/Null]
$ns attach-agent $n8 $null7
$ns connect $udp7 $null7

set udp8 [new Agent/UDP]
$ns attach-agent $n8 $udp8
set null8 [new Agent/Null]
$ns attach-agent $n9 $null8
$ns connect $udp8 $null8

set udp9 [new Agent/UDP]
$ns attach-agent $n9 $udp9
set null9 [new Agent/Null]
$ns attach-agent $n0 $null9
$ns connect $udp9 $null9

# Menambahkan aplikasi CBR pada setiap agen UDP untuk menyebarkan lalu lintas data
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packet_size_ 500
$cbr0 set rate_ 1mb

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packet_size_ 500
$cbr1 set rate_ 1mb

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set packet_size_ 500
$cbr2 set rate_ 1mb

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set packet_size_ 500
$cbr3 set rate_ 1mb

set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp4
$cbr4 set packet_size_ 500
$cbr4 set rate_ 1mb

set cbr5 [new Application/Traffic/CBR]
$cbr5 attach-agent $udp5
$cbr5 set packet_size_ 500
$cbr5 set rate_ 1mb

set cbr6 [new Application/Traffic/CBR]
$cbr6 attach-agent $udp6
$cbr6 set packet_size_ 500
$cbr6 set rate_ 1mb

set cbr7 [new Application/Traffic/CBR]
$cbr7 attach-agent $udp7
$cbr7 set packet_size_ 500
$cbr7 set rate_ 1mb

set cbr8 [new Application/Traffic/CBR]
$cbr8 attach-agent $udp8
$cbr8 set packet_size_ 500
$cbr8 set rate_ 1mb

set cbr9 [new Application/Traffic/CBR]
$cbr9 attach-agent $udp9
$cbr9 set packet_size_ 500
$cbr9 set rate_ 1mb

# Menjadwalkan mulai dan berhenti untuk setiap aplikasi CBR
$ns at 0.1 "$cbr0 start"
$ns at 0.2 "$cbr1 start"
$ns at 0.3 "$cbr2 start"
$ns at 0.4 "$cbr3 start"
$ns at 0.5 "$cbr4 start"
$ns at 0.6 "$cbr5 start"
$ns at 0.7 "$cbr6 start"
$ns at 0.8 "$cbr7 start"
$ns at 0.9 "$cbr8 start"
$ns at 1.0 "$cbr9 start"

# Menyelesaikan simulasi pada waktu tertentu
$ns at 5.0 "finish"

# Menjalankan simulasi
$ns run
