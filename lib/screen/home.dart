import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasitest/screen/create.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];

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
                  title: Text(user['Nama'] ?? 'No Name'),
                  subtitle: Text('Kota: ${user['kota'] ?? 'No City'}'),
                  trailing: Text('Usia: ${user['usia']?.toString() ?? 'N/A'}'),
                );
              },
            )
          : const Center(child: Text('No data available')),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman CreateScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateScreen()),
            );
          },
          child: const Text('Create New Entry'),
        ),
      ),
    );
  }

  void fetchData() async {
    print('Fetching data...');
    const url = 'https://selected-doe-95.hasura.app/api/rest/table_kota';
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

      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Akses data dari key 'table_kota'
        setState(() {
          users = body['table_kota'] ?? [];
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
}
