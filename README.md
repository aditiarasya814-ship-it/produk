# 📦 Produk App - Flutter & PHP Backend

[![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![PHP](https://img.shields.io/badge/Backend-PHP-777BB4?logo=php&logoColor=white)](https://www.php.net)
[![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com)

Aplikasi manajemen produk yang terintegrasi dengan database MySQL melalui REST API yang dibangun menggunakan PHP. Proyek ini mencakup sisi Frontend (Flutter) dan Backend (PHP API).

---

## 📸 Tampilan Aplikasi

| Halaman Utama | Form Tambah Produk | Detail Produk |
| :---: | :---: | :---: |
| <img width="1919" height="1026" alt="Screenshot 2026-02-25 203146" src="https://github.com/user-attachments/assets/64c371c0-0ca1-498c-85f2-78421885b648" />
 |<img width="1919" height="1037" alt="Screenshot 2026-02-25 203215" src="https://github.com/user-attachments/assets/74f664f2-1d8d-4f52-8a0e-9e3c3cfc7ab2" />
 |<img width="1919" height="1028" alt="Screenshot 2026-02-25 203204" src="https://github.com/user-attachments/assets/34889b9c-31d1-4df4-9047-8085d88f02ba" />
|

---

## 🚀 Fitur Utama
* **🌐 REST API Integration**: Komunikasi data lancar antara Flutter dan PHP.
* **📊 CRUD Operations**: Mendukung Create, Read, Update, dan Delete data produk.
* **📂 Structured Code**: Pemisahan folder antara Frontend (Flutter) dan Backend (PHP).
* **💾 Database Management**: Disertai file konfigurasi SQL untuk setup database cepat.

---

## 📂 Struktur Folder
```text
.
├── api_produk/           # ⬅️ Backend (PHP API & SQL)
│   ├── SQL.txt           # Skema Database
│   ├── konekdb.php       # Koneksi Database
│   └── *.php             # Endpoint API (List, Create, Update, Delete)
├── lib/                  # ⬅️ Frontend (Flutter)
│   ├── ui/               # Tampilan Halaman (Form, Page, Detail)
│   └── main.dart         # Entry Point Aplikasi
└── pubspec.yaml          # Library & Dependencies
