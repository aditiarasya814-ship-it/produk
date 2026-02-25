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
  List<Produk> listProduk = []; 
  List<Produk> listProdukFilter = []; 
  bool loading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ambilData();
  }

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
      setState(() => loading = false);
    }
  }

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
      backgroundColor: const Color(0xFFF8F9FA), // Warna background lebih soft
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo[800], // Warna indigo yang lebih premium
        title: const Text(
          'Inventory System',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: "Cari berdasarkan nama atau kode...",
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.indigo),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
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
        ).then((value) => ambilData()), // Refresh otomatis setelah tambah data
        label: const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_shopping_cart_rounded),
        backgroundColor: Colors.orangeAccent[700],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.indigo[800],
                strokeWidth: 5,
              ),
            )
          : listProdukFilter.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: ambilData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: listProdukFilter.length,
                    itemBuilder: (context, i) {
                      Produk item = listProdukFilter[i];
                      return _buildProductCard(item);
                    },
                  ),
                ),
    );
  }

  Widget _buildProductCard(Produk item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProdukDetail(produk: item)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Bagian Gambar
                Hero(
                  tag: 'img-${item.kode}',
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.urlGambar != null && item.urlGambar != ""
                          ? Image.network(item.urlGambar!, fit: BoxFit.cover)
                          : Icon(Icons.inventory_2_outlined, size: 40, color: Colors.indigo[200]),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Bagian Informasi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.kode ?? "NO CODE",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo[300],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.nama ?? "Unknown Product",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Produk.formatRupiah(item.harga ?? 0),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Produk tidak ditemukan",
            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}