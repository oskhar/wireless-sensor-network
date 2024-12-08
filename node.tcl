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

# Membuat node seperti arsitektur jembatan Golden Gate dengan jarak yang lebih lebar
set n0 [$ns node]
$n0 set X_ 50.0
$n0 set Y_ 200.0

set n1 [$ns node]
$n1 set X_ 200.0
$n1 set Y_ 400.0

set n2 [$ns node]
$n2 set X_ 400.0
$n2 set Y_ 600.0

set n3 [$ns node]
$n3 set X_ 600.0
$n3 set Y_ 400.0

set n4 [$ns node]
$n4 set X_ 800.0
$n4 set Y_ 200.0

set n5 [$ns node]
$n5 set X_ 1000.0
$n5 set Y_ 400.0

set n6 [$ns node]
$n6 set X_ 1200.0
$n6 set Y_ 600.0

set n7 [$ns node]
$n7 set X_ 1400.0
$n7 set Y_ 400.0

set n8 [$ns node]
$n8 set X_ 1600.0
$n8 set Y_ 200.0

# Menghubungkan node untuk membentuk jembatan Golden Gate
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n4 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n5 $n6 2Mb 10ms DropTail
$ns duplex-link $n6 $n7 2Mb 10ms DropTail
$ns duplex-link $n7 $n8 2Mb 10ms DropTail

# Menambahkan link tambahan untuk menambah stabilitas jembatan
$ns duplex-link $n0 $n4 2Mb 15ms DropTail
$ns duplex-link $n4 $n8 2Mb 15ms DropTail
$ns duplex-link $n2 $n6 2Mb 20ms DropTail

# Menambahkan orientasi link untuk visualisasi di NAM
$ns duplex-link-op $n0 $n1 orient up-right
$ns duplex-link-op $n1 $n2 orient up-right
$ns duplex-link-op $n2 $n3 orient right-down
$ns duplex-link-op $n3 $n4 orient down-right
$ns duplex-link-op $n4 $n5 orient up-right
$ns duplex-link-op $n5 $n6 orient up-right
$ns duplex-link-op $n6 $n7 orient right-down
$ns duplex-link-op $n7 $n8 orient down-right
$ns duplex-link-op $n0 $n4 orient right
$ns duplex-link-op $n4 $n8 orient right
$ns duplex-link-op $n2 $n6 orient right

# Menambahkan agen UDP dan Null untuk simulasi traffic
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null8 [new Agent/Null]
$ns attach-agent $n8 $null8
$ns connect $udp0 $null8

# Menambahkan aplikasi CBR
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packet_size_ 500
$cbr0 set rate_ 1mb

# Menjadwalkan mulai dan berhenti untuk aplikasi CBR
$ns at 0.1 "$cbr0 start"
$ns at 5.0 "finish"

# Menjalankan simulasi
$ns run