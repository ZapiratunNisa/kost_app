import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:image_picker/image_picker.dart';

import '../utils/api.dart';

class AddKostPage extends StatefulWidget {
  @override
  _AddKostPageState createState() => _AddKostPageState();
}

class _AddKostPageState extends State<AddKostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nama = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController harga = TextEditingController();

  File? _image; // Android/iOS
  Uint8List? _webImage; // Web
  String? _webImageName;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _webImageName = pickedFile.name;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      var request = http.MultipartRequest('POST', Uri.parse(Api.addKost));
      request.fields['nama_kost'] = nama.text;
      request.fields['alamat'] = alamat.text;
      request.fields['harga'] = harga.text;

      if (kIsWeb && _webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'gambar',
          _webImage!,
          filename: _webImageName ?? 'web_image.jpg',
        ));
      } else if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'gambar',
          _image!.path,
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);

      if (response.statusCode == 200 && data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${data['message']}")),
        );
        nama.clear();
        alamat.clear();
        harga.clear();
        setState(() {
          _image = null;
          _webImage = null;
        });

        Navigator.pop(context, true); // Penting agar HomePage refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("❌ ${data['message'] ?? 'Gagal menyimpan data'}")),
        );
      }
    }
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
            title: const Text("Tambah Kost"),
            backgroundColor: Colors.pink,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(Icons.house, size: 60, color: Colors.pink),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'Tambah Kost',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: nama,
                        decoration: const InputDecoration(
                          labelText: "Nama Kost",
                          prefixIcon: Icon(Icons.house),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Nama kost tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: alamat,
                        decoration: const InputDecoration(
                          labelText: "Alamat Kost",
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: harga,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Harga per bulan",
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harga tidak boleh kosong";
                          } else if (int.tryParse(value) == null ||
                              int.parse(value) < 0) {
                            return "Harga harus berupa angka positif";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Gambar Kost",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Pilih Gambar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      (kIsWeb && _webImage != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                _webImage!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : (_image != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _image!,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Belum ada gambar dipilih"),
                                ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text(
                            "Simpan Data",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: simpan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
