import 'package:flutter/material.dart';
import 'screens/reto1_page.dart';
import 'screens/reto2_page.dart';
import 'screens/reto3_page.dart';
import 'screens/reto4_page.dart';


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
  final WidgetBuilder? pantalla;

  const Reto(this.titulo, this.subtitulo, this.icono, [this.pantalla]);
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static final List<Reto> retos = [
    Reto('Reto 1', 'Recomendador de películas', Icons.movie,
        (_) => const Reto1Page()),
    Reto('Reto 2', 'Memes de gatos', Icons.pets, (_) => const Reto2Page()),
    Reto('Reto 3', 'Clima minimalista', Icons.wb_sunny, (_) => const Reto3Page()),
    Reto('Reto 4', 'Convertidor de criptomonedas', Icons.currency_bitcoin, (_) => const Reto4Page()),
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
                if (reto.pantalla == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${reto.titulo} próximamente')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: reto.pantalla!),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
