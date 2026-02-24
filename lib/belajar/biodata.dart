import 'dart:io';

void main() {
Biodata biodata = Biodata(
    'Muhammad Revan','Maulana Safa', 
    'XII RPL 2', 'XII RPL 2',
    'Manusia Serigala', 'Manusia Kelelawar',
    1.9, 2.0,
    19, 19);
biodata.safa();
biodata.revan();

while (true){
    print('==Tampilkan Database Seseorang==');
    print('1. Revan');
    print('2. Safa');
    print('3. Keluar');
    stdout.write('Pilih Menu (1-2): ');
    
    var input = stdin.readLineSync();
    int pil = int.tryParse(input ?? '') ?? 0;

    if (pil == 3) {
        print('Program Di Tutups');
        break;
    }

    if (pil < 1 || pil > 2) {
        print('Tidak valid, masukan anka kembali');
        continue;
    }

    switch (pil) {
        case 1:
        print('biodata1');
        break;
        case 2:
        print('biodata2');
    } 
}
}

class Biodata {
String name1,name2, kelas1,  kelas2, gen1,  gen2;
double tinggi1, tinggi2;
int umur1, umur2;

Biodata(this.name1, this.name2, this.kelas1, this.kelas2, this.gen1, this.gen2, this.tinggi1, this.tinggi2, this.umur1, this.umur2);

void safa() {
// print('=====BIODATA $name1=====');
// print('Nama  :  $name1');
// print('Kelas :  $kelas1');
// print('Gen   :  $gen1');
// print('Tinggi:  $tinggi1 M');
// print('Umur  :  $umur1');
}

void revan() {
// print('=====BIODATA $name2=====');
// print('Nama  :  $name2');
// print('Kelas :  $kelas2');
// print('Gen   :  $gen2');
// print('Tinggi:  $tinggi2 M');
// print('Umur  :  $umur2');
// print('=================');
}

}

//by revan