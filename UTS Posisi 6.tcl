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

# Menyusun node dalam bentuk kelinci
# Kepala dan telinga kelinci
set n0 [$ns node]      ;# Kepala
$n0 set X_ 250.0
$n0 set Y_ 300.0

set n1 [$ns node]      ;# Telinga kiri
$n1 set X_ 230.0
$n1 set Y_ 350.0

set n2 [$ns node]      ;# Telinga kanan
$n2 set X_ 270.0
$n2 set Y_ 350.0

# Badan kelinci
set n3 [$ns node]      ;# Badan atas
$n3 set X_ 250.0
$n3 set Y_ 250.0

set n4 [$ns node]      ;# Badan tengah
$n4 set X_ 250.0
$n4 set Y_ 200.0

set n5 [$ns node]      ;# Badan bawah
$n5 set X_ 250.0
$n5 set Y_ 150.0

# Kaki kelinci
set n6 [$ns node]      ;# Kaki kiri depan
$n6 set X_ 230.0
$n6 set Y_ 120.0

set n7 [$ns node]      ;# Kaki kanan depan
$n7 set X_ 270.0
$n7 set Y_ 120.0

set n8 [$ns node]      ;# Kaki kiri belakang
$n8 set X_ 230.0
$n8 set Y_ 80.0

set n9 [$ns node]      ;# Kaki kanan belakang
$n9 set X_ 270.0
$n9 set Y_ 80.0

# Menghubungkan node untuk membentuk pola kelinci
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n4 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n5 $n6 2Mb 10ms DropTail
$ns duplex-link $n5 $n7 2Mb 10ms DropTail
$ns duplex-link $n6 $n8 2Mb 10ms DropTail
$ns duplex-link $n7 $n9 2Mb 10ms DropTail

# Orientasi link untuk visualisasi yang lebih baik di NAM
$ns duplex-link-op $n0 $n1 orient up-left
$ns duplex-link-op $n0 $n2 orient up-right
$ns duplex-link-op $n0 $n3 orient down
$ns duplex-link-op $n3 $n4 orient down
$ns duplex-link-op $n4 $n5 orient down
$ns duplex-link-op $n5 $n6 orient left-down
$ns duplex-link-op $n5 $n7 orient right-down
$ns duplex-link-op $n6 $n8 orient down
$ns duplex-link-op $n7 $n9 orient down

# Menambahkan agen UDP dan Null di setiap node untuk mengirim dan menerima data
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n9 $null0
$ns connect $udp0 $null0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n8 $null1
$ns connect $udp1 $null1

set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n7 $null2
$ns connect $udp2 $null2

set udp3 [new Agent/UDP]
$ns attach-agent $n3 $udp3
set null3 [new Agent/Null]
$ns attach-agent $n6 $null3
$ns connect $udp3 $null3

set udp4 [new Agent/UDP]
$ns attach-agent $n4 $udp4
set null4 [new Agent/Null]
$ns attach-agent $n5 $null4
$ns connect $udp4 $null4

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

# Menjadwalkan mulai dan berhenti untuk setiap aplikasi CBR
$ns at 0.1 "$cbr0 start"
$ns at 0.2 "$cbr1 start"
$ns at 0.3 "$cbr2 start"
$ns at 0.4 "$cbr3 start"
$ns at 0.5 "$cbr4 start"

# Menyelesaikan simulasi pada waktu tertentu
$ns at 5.0 "finish"

# Menjalankan simulasi
$ns run
