import 'package:flutter/material.dart';
import 'package:tugas_pkl/daftar_pelanggan.dart';
import 'package:tugas_pkl/detail_pelanggan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DaftarPelanggan(),
        '/customerDetail': (context) => const DetailPelanggan(),
      },
    );
  }
}