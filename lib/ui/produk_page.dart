import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan/ui/produk.dart';
import 'package:latihan/ui/api.dart';
import 'package:latihan/ui/produk_form.dart';
import 'package:latihan/ui/produk_detail.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Produk> listProduk = []; // Data asli dari database
  List<Produk> listProdukFilter = []; // Data yang tampil (setelah search)
  bool loading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  // Fungsi ambil data diubah agar mengisi listProduk
  Future<void> ambilData() async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.data));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          listProduk = data.map((item) => Produk.fromJson(item)).toList();
          listProdukFilter = listProduk; 
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error Ambil Data: $e");
    }
  }

  // FUNGSI SEARCH: Memfilter list berdasarkan input user
  void filterSearch(String query) {
    setState(() {
      listProdukFilter = listProduk
          .where((produk) =>
              produk.nama!.toLowerCase().contains(query.toLowerCase()) ||
              produk.kode!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Katalog Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch, // Panggil fungsi filter saat mengetik
              decoration: InputDecoration(
                hintText: "Cari nama atau kode produk...",
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProdukForm()),
        ),
        label: const Text("Tambah"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : listProdukFilter.isEmpty
              ? const Center(child: Text("Produk tidak ditemukan"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: listProdukFilter.length,
                  itemBuilder: (context, i) {
                    Produk item = listProdukFilter[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProdukDetail(produk: item)),
                        ),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: item.urlGambar != null && item.urlGambar != ""
                                ? Image.network(item.urlGambar!, fit: BoxFit.cover)
                                : const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                        title: Text(item.nama ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(Produk.formatRupiah(item.harga ?? 0), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ),
                    );
                  },
                ),
    );
  }
}