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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background lebih bersih
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // GAMBAR PRODUK (Dengan Frame yang lebih halus)
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0), // Efek bingkai putih
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        widget.produk?.urlGambar != null &&
                            widget.produk?.urlGambar != ""
                        ? Image.network(
                            widget.produk!.urlGambar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                          )
                        : const Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    "${widget.produk?.nama}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Produk.formatRupiah(widget.produk?.harga ?? 0),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // BOX KATEGORI
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Text(
                      widget.produk?.kategori ?? "Tanpa Kategori",
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.produk?.deskripsi ??
                          "Tidak ada deskripsi untuk produk ini.",
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Card untuk Info Kode
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.qr_code,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "SKU: ${widget.produk?.kode}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // TOMBOL AKSI (Warna yang lebih soft)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProdukForm(produk: widget.produk),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_note),
                          label: const Text("EDIT"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber[800],
                            side: BorderSide(color: Colors.amber[800]!),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => konfirmasiHapus(),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text("HAPUS"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red[50], // Background merah sangat muda
                            foregroundColor: Colors.red[700], // Teks merah tua
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.red[100]!),
                            ),
                          ),
                        ),
                      ),
                    ],
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
