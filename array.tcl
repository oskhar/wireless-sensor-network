# Mengatur nilai array bulan
array set bulan {
    1   Januari
    2   Februari
    3   Maret
    4   April
    5   Mei
    6   Juni
    7   Juli
    8   Agustus
    9   September
    10  Oktober
    11  November
    12  Desember
}

for {set i 1} {$i <= [array size bulan]} {incr i} {
    puts "Bulan $i = $bulan($i)"
}