import 'dart:io';

void main() {
  while (true) {
    print('\n=== KALKULATOR SEDERHANA ===');
    print('1. Tambah  2. Kurang  3. Kali');
    print('4. Bagi    5. Sisa    6. Keluar');
    stdout.write('Pilih menu (1-6): ');
    
    var input = stdin.readLineSync();
    int pil = int.tryParse(input ?? '') ?? 0;

    if (pil == 6) {
      print('Selesai, terima kasih!');
      break;
    }

    if (pil < 1 || pil > 5) {
      print('Pilihan gak valid, coba lagi.');
      continue;
    }

    stdout.write('Masukkan angka pertama: ');
    double a = double.parse(stdin.readLineSync()!);
    stdout.write('Masukkan angka kedua: ');
    double b = double.parse(stdin.readLineSync()!);

    double hasil = 0;
    switch (pil) {
      case 1:
        hasil = a + b;
        break;
      case 2:
        hasil = a - b;
        break;
      case 3:
        hasil = a * b;
        break;
      case 4:
        if (b == 0) {
          print('Error: Gak bisa dibagi nol!');
          continue;
        }
        hasil = a / b;
        break;
      case 5:
        hasil = a % b;
        break;
    }

    print('Hasilnya: $hasil');
  }
}