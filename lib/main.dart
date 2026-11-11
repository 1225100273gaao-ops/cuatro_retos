import 'package:flutter/material.dart';

void main() {
  runApp(const CuatroRetosApp());
}

class CuatroRetosApp extends StatelessWidget {
  const CuatroRetosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuatro Retos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}

class Reto {
  final String titulo;
  final String subtitulo;
  final IconData icono;

  const Reto(this.titulo, this.subtitulo, this.icono);
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static const List<Reto> retos = [
    Reto('Reto 1', 'Recomendador de películas', Icons.movie),
    Reto('Reto 2', 'Memes de gatos', Icons.pets),
    Reto('Reto 3', 'Clima minimalista', Icons.wb_sunny),
    Reto('Reto 4', 'Convertidor de criptomonedas', Icons.currency_bitcoin),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Los Cuatro Retos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: retos.length,
        itemBuilder: (context, index) {
          final reto = retos[index];
          return Card(
            child: ListTile(
              leading: Icon(reto.icono, size: 32),
              title: Text(reto.titulo),
              subtitle: Text(reto.subtitulo),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${reto.titulo} próximamente')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}