## Soal latihan 3
# 1. Buatlah program TCL seperti pada modul dengan modifikasi node sebanyak 8 buah di mana node 1 terhubung pada node 2, 3, dan4. 
#     - Node 2 terhubung Node 7
#     - Node 3 terhubung Node 6
#     - Node 4 terhubung Node 5
#     - Node 5, 6, 7 terhubung pada node akhir/tujuan node 8.
#     - Dengan 3 warna pengiriman paket dari node 1 ke arah node 2, 3, 4.

# Buat objek simulator
set ns [new Simulator]

# Definisikan warna untuk pengiriman data (untuk NAM)
$ns color 1 Blue   ;# Warna pengiriman paket dari node 1 ke node 2
$ns color 2 Green  ;# Warna pengiriman paket dari node 1 ke node 3
$ns color 3 Red    ;# Warna pengiriman paket dari node 1 ke node 4

# Buka file trace NAM
set nf [open out.nam w]
$ns namtrace-all $nf

# Prosedur untuk mengakhiri simulasi
proc finish {} {
    global ns nf
    $ns flush-trace
    # Tutup file NAM
    close $nf
    # Jalankan NAM untuk melihat hasil simulasi
    exec nam out.nam &
    exit 0
}

# Buat delapan node
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]

# Buat link antara node sesuai topologi
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n3 2Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail
$ns duplex-link $n2 $n7 2Mb 10ms DropTail
$ns duplex-link $n3 $n6 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n5 $n8 1.7Mb 10ms DropTail
$ns duplex-link $n6 $n8 1.7Mb 10ms DropTail
$ns duplex-link $n7 $n8 1.7Mb 10ms DropTail

# Set Queue Size untuk beberapa link
$ns queue-limit $n5 $n8 10
$ns queue-limit $n6 $n8 10
$ns queue-limit $n7 $n8 10

# Beri posisi node untuk NAM
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n1 $n4 orient right-down
$ns duplex-link-op $n2 $n7 orient right
$ns duplex-link-op $n3 $n6 orient right
$ns duplex-link-op $n4 $n5 orient right
$ns duplex-link-op $n5 $n8 orient right
$ns duplex-link-op $n6 $n8 orient right
$ns duplex-link-op $n7 $n8 orient right

# Monitor antrian pada link (n5-n8, n6-n8, n7-n8) untuk NAM
$ns duplex-link-op $n5 $n8 queuePos 0.5
$ns duplex-link-op $n6 $n8 queuePos 0.5
$ns duplex-link-op $n7 $n8 queuePos 0.5

# Setup koneksi TCP dari node 1 ke node 2, 3, 4
set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 1

set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n1 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n3 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 2

set tcp3 [new Agent/TCP]
$tcp3 set class_ 2
$ns attach-agent $n1 $tcp3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n4 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 3

# Setup aplikasi FTP di atas TCP
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3

# Jadwalkan event untuk pengiriman data
$ns at 0.1 "$ftp1 start"
$ns at 0.2 "$ftp2 start"
$ns at 0.3 "$ftp3 start"
$ns at 2.0 "$ftp1 stop"
$ns at 2.1 "$ftp2 stop"
$ns at 2.2 "$ftp3 stop"

# Prosedur untuk menghentikan simulasi
$ns at 2.5 "finish"

# Jalankan simulasi
$ns run
