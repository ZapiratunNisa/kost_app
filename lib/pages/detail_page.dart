import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map data;
  DetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gambar latar belakang
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_home.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay semi-transparan agar konten tetap terlihat
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(data['nama_kost']),
            backgroundColor: Colors.pink,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO KOST
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      data['foto'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 100, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // NAMA KOST
                  Text(
                    data['nama_kost'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ALAMAT
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          data['alamat'],
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // HARGA
                  Card(
                    color: Colors.pink.shade50.withOpacity(0.9),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.pink),
                          const SizedBox(width: 12),
                          Text(
                            "Harga: Rp ${data['harga']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // TOMBOL HUBUNGI
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text(
                        "Hubungi Pemilik",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("📞 Fitur belum tersedia")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
