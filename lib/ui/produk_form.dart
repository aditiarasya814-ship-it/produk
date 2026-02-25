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
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error detail: $e");
      return false;
    }
  }

  // Helper Widget untuk TextField yang lebih modern
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF34495E),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: type,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.indigo[800], size: 20),
              hintText: "Masukkan $label",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.produk == null ? 'New Product' : 'Update Product',
          style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
        ),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section untuk Preview Gambar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.indigo[800],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
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
                                  const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            )
                          : Icon(Icons.add_photo_alternate_rounded, size: 50, color: Colors.indigo[100]),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Product Preview",
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildTextField(_kodeController, "Product Code", Icons.qr_code_2_rounded),
                  _buildTextField(_namaController, "Product Name", Icons.edit_note_rounded),
                  _buildTextField(
                    _hargaController, 
                    "Price", 
                    Icons.payments_rounded,
                    type: TextInputType.number,
                  ),
                  _buildTextField(_gambarController, "Image URL", Icons.link_rounded),
                  _buildTextField(_kategoriController, "Category", Icons.category_rounded),
                  _buildTextField(
                    _deskripsiController, 
                    "Description", 
                    Icons.description_rounded,
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Tombol Simpan yang lebih elegan
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent[700],
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.orangeAccent.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_kodeController.text.isEmpty ||
                            _namaController.text.isEmpty ||
                            _hargaController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill Code, Name, and Price!"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(child: CircularProgressIndicator(color: Colors.indigo[800])),
                        );

                        bool sukses = await simpanProduk();
                        
                        if (!mounted) return;
                        Navigator.pop(context);

                        if (sukses) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const ProdukPage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to save. Check connection or database."),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Text(
                        widget.produk == null ? "CREATE PRODUCT" : "UPDATE PRODUCT",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
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