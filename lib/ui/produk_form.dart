import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latihan/ui/api.dart';
import 'package:latihan/ui/produk.dart';
import 'package:latihan/ui/produk_page.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _gambarController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      _kodeController.text = widget.produk!.kode ?? "";
      _namaController.text = widget.produk!.nama ?? "";
      _hargaController.text = widget.produk!.harga.toString();
      _gambarController.text = widget.produk!.urlGambar ?? "";
      _kategoriController.text = widget.produk!.kategori ?? "";
      _deskripsiController.text = widget.produk!.deskripsi ?? "";
    }
    _gambarController.addListener(() => setState(() {}));
  }

  Future<bool> simpanProduk() async {
    // Pastikan URL berganti saat edit
    String url = (widget.produk == null) ? BaseUrl.tambah : BaseUrl.edit;
    
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": widget.produk?.id, 
          "kode": _kodeController.text,
          "nama": _namaController.text,
          "harga": _hargaController.text,
          "url_gambar": _gambarController.text,
          "kategori": _kategoriController.text,
          "deskripsi": _deskripsiController.text,
        }),
      ).timeout(const Duration(seconds: 10)); // Tambahkan timeout untuk keamanan

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error detail: $e");
      return false;
    }
  }

  // Widget Helper dengan UI lebih halus
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 22),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: _gambarController.text.isNotEmpty
                      ? Image.network(
                          _gambarController.text,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        )
                      : Icon(Icons.add_a_photo_rounded, size: 60, color: Colors.blueGrey[200]),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  _buildTextField(_kodeController, "Kode Produk", Icons.qr_code_scanner),
                  _buildTextField(_namaController, "Nama Produk", Icons.shopping_bag_outlined),
                  _buildTextField(
                    _hargaController, 
                    "Harga (Rupiah)", 
                    Icons.monetization_on_outlined,
                    type: TextInputType.number,
                  ),
                  _buildTextField(_gambarController, "Link URL Gambar", Icons.link_rounded),
                  _buildTextField(_kategoriController, "Kategori", Icons.grid_view_rounded),
                  _buildTextField(
                    _deskripsiController, 
                    "Deskripsi Lengkap", 
                    Icons.notes_rounded,
                    maxLines: 4,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (_kodeController.text.isEmpty ||
                            _namaController.text.isEmpty ||
                            _hargaController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Kode, Nama, dan Harga tidak boleh kosong!"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        // Menampilkan Loading Dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );

                        bool sukses = await simpanProduk();
                        
                        if (!mounted) return;
                        Navigator.pop(context); // Tutup Loading

                        if (sukses) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const ProdukPage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Gagal menyimpan data. Periksa koneksi atau database."),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Text(
                        widget.produk == null ? "SIMPAN DATA BARU" : "SIMPAN PERUBAHAN",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}