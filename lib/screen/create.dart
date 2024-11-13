import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:aplikasitest/model/user.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _kotaController = TextEditingController();
  final _usiaController = TextEditingController();

  // Fungsi untuk mengirim data melalui GraphQL POST
  Future<void> createData() async {
    final String id = _idController.text;
    final String nama = _nameController.text;
    final String kota = _kotaController.text;
    final int? usia = int.tryParse(_usiaController.text);

    if (nama.isNotEmpty && kota.isNotEmpty && usia != null) {
      const url = 'https://selected-doe-95.hasura.app/v1/graphql';
      final uri = Uri.parse(url);

      // GraphQL Mutation Query
      const mutation = '''
        mutation insertTableKota(\$object: table_kota_insert_input!) {
          insert_table_kota_one(object: \$object) {
            id
            Nama
            kota
            usia
          }
        }
      ''';

      // Membuat variabel untuk GraphQL
      final variables = {
        "object": {
          "id": int.tryParse(id) ?? null, // Bisa juga diisi null jika auto-increment
          "Nama": nama,
          "kota": kota,
          "usia": usia,
        }
      };

      // Mengirim data ke API menggunakan metode POST
      try {
        final response = await http.post(
          uri,
          headers: {
            'x-hasura-admin-secret':
                'pnvX69BdXPPEKOtmqcaVL9H8wxX4TglwZF3r6Domqpw7MJUW6hZ3ZEQpx6uonNXE',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "query": mutation,
            "variables": variables,
          }),
        );

        if (response.statusCode == 200) {
          // Jika berhasil
          print('Data created successfully');
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        } else {
          // Jika gagal
          print('Failed to create data: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      } catch (e) {
        print('An error occurred: $e');
      }
    } else {
      print('Please fill in all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ID (Optional)'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _kotaController,
              decoration: const InputDecoration(labelText: 'Kota'),
            ),
            TextField(
              controller: _usiaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Usia'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createData,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
