import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_kost_page.dart';
import 'detail_page.dart';
import '../utils/api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List kostList = [];

  void getKost() async {
    try {
      final response = await http.get(Uri.parse(Api.getKost));
      final data = jsonDecode(response.body);

      if (mounted && data['status'] == true) {
        setState(() => kostList = data['data']);
      }
    } catch (e) {
      print("Error fetching kost: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat data kost")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getKost();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_home.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(color: Colors.black.withOpacity(0.3)),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("🏠 Daftar Kost"),
            backgroundColor: Colors.pinkAccent,
            elevation: 0,
          ),
          body: kostList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: kostList.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final item = kostList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetailPage(data: item)),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                item['foto'],
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 160,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported, size: 80),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['nama_kost'],
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Rp ${item['harga']}",
                                    style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          item['alamat'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.grey),
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
                  },
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: () async {
              final refresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddKostPage()),
              );
              if (refresh == true) getKost();
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
