// lib/order_kost_page.dart
import 'package:flutter/material.dart';

class OrderKostPage extends StatelessWidget {
  final Map data;
  const OrderKostPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan Kost'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Kost: ${data['nama_kost']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Alamat: ${data['alamat']}"),
            SizedBox(height: 8),
            Text("Harga: Rp ${data['harga']}"),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ Kost berhasil dipesan (simulasi)")),
                );
              },
              child: Text("Pesan Sekarang"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            ),
          ],
        ),
      ),
    );
  }
}
