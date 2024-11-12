import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasitest/model/user.dart';
import 'create.dart'; // Import halaman create baru

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = []; // Menggunakan list User

  @override
  void initState() {
    super.initState();
    fetchData(); // Memanggil fetchData saat HomeScreen pertama kali dibuka
  }

  // Method untuk mengambil data dari server
  void fetchData() async {
    print('Fetching data...');
    const url = 'https://selected-doe-95.hasura.app/api/rest/tabel_kota'; // Perbarui URL
    final uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-hasura-admin-secret':
              'pnvX69BdXPPEKOtmqcaVL9H8wxX4TglwZF3r6Domqpw7MJUW6hZ3ZEQpx6uonNXE',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        setState(() {
          users = (body['tabel_kota'] as List) // Perbarui 'tabel_kota' dari respons
              .map((userJson) => User.fromJson(userJson))
              .toList(); // Mengubah JSON ke list of User
        });
        print('Data fetched successfully: ${users.length} items');
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: users.isNotEmpty
          ? ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.nama),
                  subtitle: Text('Kota: ${user.kota}'),
                  trailing: Text('Usia: ${user.usia}'),
                );
              },
            )
          : const Center(child: Text('No data available')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}