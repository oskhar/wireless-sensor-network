# Membuat instance simulator baru
set ns [new Simulator]

# Mengatur warna dari arus data
$ns color 1 Blue
$ns color 2 Green

# Mencatat semua informasi simulasi
set tr [open "out.tr" w]
$ns trace-all $tr

# Membuat NAM file trace
set namfile [open "out.nam" w]
$ns namtrace-all $namfile

# Inisiasi procedure finish
proc finish {} {
    global ns tr namfile
    $ns flush-trace
    close $tr
    close $namfile
    exec nam out.nam &
    exit 0
}

# Membuat 5 node menggunakan perulangan for
array set n {}
for {set i 0} {$i < 5} {incr i} {
    set n($i) [$ns node]
}

# Menghubungkan setiap node yang ada
$ns duplex-link $n(0) $n(1) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(4) 1.7Mb 10ms DropTail
$ns duplex-link $n(0) $n(3) 2Mb 10ms DropTail
$ns duplex-link $n(3) $n(4) 1.7Mb 10ms DropTail

# Mengatur ukuran queue dari node 2 <-> 4 dan 3 <-> 4
$ns queue-limit $n(2) $n(4) 10
$ns queue-limit $n(3) $n(4) 10

# Mengatur posisi aliran data pada node
$ns duplex-link-op $n(0) $n(1) orient right-up
$ns duplex-link-op $n(1) $n(2) orient right
$ns duplex-link-op $n(2) $n(4) orient right-down
$ns duplex-link-op $n(0) $n(3) orient right
$ns duplex-link-op $n(3) $n(4) orient right

# Monitor queue untuk node 2 <-> 4
$ns duplex-link-op $n(2) $n(4) queuePos 0.5

# Mengatur koneksi TCP
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n(2) $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n(2) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n(4) $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 1

# Mengatur FTP pada koneksi TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

# Mengatur koneksi UDP
set udp [new Agent/UDP]
$ns attach-agent $n(0) $udp
set null [new Agent/Null]
$ns attach-agent $n(4) $null
$ns connect $udp $null
$udp set fid_ 2

# Mengatur CBR pada koneksi UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

# Schedule events cbr dan ftp
$ns at 0.1 "$cbr start"
$ns at 0.8 "$ftp start"
$ns at 1.0 "$ftp2 start"
$ns at 3.8 "$cbr stop"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$ftp2 stop"

# Melepas agent tcp dan sink setelah selesai
$ns at 4.5 "$ns detach-agent $n(0) $tcp; $ns detach-agent $n(4) $sink2"

# Memanggil procedure finish
$ns at 5.0 "finish"

# Mencetak ukuran paket cbr dan interval cbr
puts "CBR packet size = {$cbr set packet_size_}"
puts "CBR interval = {$cbr set interval_}"

# Jalankan simulasi
$ns run
