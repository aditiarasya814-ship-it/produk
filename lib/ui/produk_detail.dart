import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan/ui/api.dart';
import 'package:latihan/ui/produk.dart';
import 'package:latihan/ui/produk_page.dart';
import 'package:latihan/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;
  const ProdukDetail({super.key, this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  Future<bool> hapusData() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.hapus),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.produk?.id}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error Hapus: $e");
    }
    return false;
  }

  void konfirmasiHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text("Hapus Produk"),
          ],
        ),
        content: const Text("Apakah Anda yakin ingin menghapus produk ini secara permanen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("BATAL", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              bool sukses = await hapusData();
              if (sukses && mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdukPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("HAPUS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: const Text('Product Detail', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image Section
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.indigo[800],
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Hero(
                        tag: 'img-${widget.produk?.kode}',
                        child: widget.produk?.urlGambar != null && widget.produk?.urlGambar != ""
                            ? Image.network(widget.produk!.urlGambar!, fit: BoxFit.cover)
                            : Icon(Icons.inventory_2_outlined, size: 100, color: Colors.indigo[50]),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama & Harga
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "${widget.produk?.nama}".toUpperCase(),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2D3436), letterSpacing: 1),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Produk.formatRupiah(widget.produk?.harga ?? 0),
                          style: TextStyle(fontSize: 22, color: Colors.green[700], fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Info Grid (Kategori & SKU)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoTile(Icons.category_rounded, "Category", widget.produk?.kategori ?? "-"),
                      _buildInfoTile(Icons.qr_code_2_rounded, "SKU Code", widget.produk?.kode ?? "-"),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2D3436)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.produk?.deskripsi ?? "No description available for this item.",
                    style: const TextStyle(color: Colors.black54, height: 1.6, fontSize: 15),
                  ),

                  const SizedBox(height: 50),

                  // Bottom Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProdukForm(produk: widget.produk)),
                            );
                          },
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: const Text("EDIT PRODUCT"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          onPressed: () => konfirmasiHapus(),
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.orangeAccent[700]),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
      ],
    );
  }
}