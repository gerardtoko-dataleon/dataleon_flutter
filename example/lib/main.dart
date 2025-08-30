import 'package:flutter/material.dart';
import 'package:dataleon_flutter/dataleon_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dataleon SDK Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dataleon SDK Flutter')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Dataleon.launch(
              context: context,
              sessionUrl: 'https://id.dataleon.ai/w/76bf997a-xxxxx',
              onResult: (status, [error]) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Status: $status ${error ?? ''}')),
                );
              },
            );
          },
          child: const Text('Lancer vérification'),
        ),
      ),
    );
  }
}
