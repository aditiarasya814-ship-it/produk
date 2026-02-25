# 📦 Produk App - Flutter & PHP Backend

[![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![PHP](https://img.shields.io/badge/Backend-PHP-777BB4?logo=php&logoColor=white)](https://www.php.net)
[![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Aplikasi manajemen inventaris produk modern yang dibangun dengan **Flutter** sebagai *frontend* dan **PHP** sebagai *backend* (REST API). Aplikasi ini memungkinkan pengguna untuk mengelola data produk secara real-time yang tersimpan dalam database MySQL.

---

## 📸 Tampilan Aplikasi (Preview)

| Halaman Utama | Form Tambah & Edit | Detail Produk |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/64c371c0-0ca1-498c-85f2-78421885b648" width="250" /> | <img src="https://github.com/user-attachments/assets/74f664f2-1d8d-4f52-8a0e-9e3c3cfc7ab2" width="250" /> | <img src="https://github.com/user-attachments/assets/34889b9c-31d1-4df4-9047-8085d88f02ba" width="250" /> |
| *List Produk & Search* | *Input Data Modern* | *Informasi Detail* |

---

## 🚀 Fitur Utama

* **⚡ Real-time CRUD**: Tambah, Lihat, Ubah, dan Hapus data tanpa delay.
* **🔍 Smart Search**: Fitur pencarian produk berdasarkan nama atau kode secara instan.
* **📱 Modern UI/UX**: Desain antarmuka bersih dengan palet warna Indigo & Orange.
* **🌐 RESTful API**: Komunikasi data terstandarisasi menggunakan JSON.
* **🔄 Pull-to-Refresh**: Memperbarui data katalog dengan sekali tarik.

---

## 🛠️ Stack Teknologi

- **Frontend**: Flutter (Dart)
- **Backend**: PHP (Native)
- **Database**: MySQL
- **HTTP Client**: `http` package
- **Server Lokal**: XAMPP / Laragon

---

## 📂 Struktur Proyek

```text
.
├── api_produk/           # ⬅️ Backend (PHP API)
│   ├── konekdb.php       # Konfigurasi database MySQL
│   ├── list.php          # GET: Mengambil semua data produk
│   ├── create.php        # POST: Menambah produk baru
│   ├── update.php        # POST: Memperbarui data produk
│   ├── delete.php        # POST: Menghapus produk
│   └── SQL.txt           # Skema Tabel Database
│
├── lib/                  # ⬅️ Frontend (Flutter)
│   ├── ui/               
│   │   ├── produk_page.dart    # Katalog utama
│   │   ├── produk_form.dart    # Form tambah/edit
│   │   └── produk_detail.dart  # Informasi lengkap produk
│   ├── models/           # Logic & Model Data
│   └── main.dart         # Titik masuk aplikasi
└── pubspec.yaml          # Dependencies proyek
