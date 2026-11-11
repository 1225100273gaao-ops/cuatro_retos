import 'package:flutter/material.dart';

import '../models/pelicula.dart';
import '../services/tmdb_service.dart';

class _Mood {
  final String nombre;
  final IconData icono;
  final int generoId;

  const _Mood(this.nombre, this.icono, this.generoId);
}

class Reto1Page extends StatefulWidget {
  const Reto1Page({super.key});

  @override
  State<Reto1Page> createState() => _Reto1PageState();
}

class _Reto1PageState extends State<Reto1Page> {
  static const List<_Mood> _moods = [
    _Mood('Feliz', Icons.sentiment_very_satisfied, 35),
    _Mood('Triste', Icons.sentiment_dissatisfied, 18),
    _Mood('Emocionado', Icons.bolt, 28),
    _Mood('Relajado', Icons.spa, 16),
    _Mood('Romántico', Icons.favorite, 10749),
  ];

  final TmdbService _servicio = TmdbService();
  int _moodIndex = 0;
  late Future<Pelicula> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _servicio.alAzar(_moods[_moodIndex].generoId);
  }

  void _buscar() {
    setState(() {
      _futuro = _servicio.alAzar(_moods[_moodIndex].generoId);
    });
  }

  void _cambiarMood(int index) {
    _moodIndex = index;
    _buscar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recomendador de películas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: List.generate(_moods.length, (i) {
                return ChoiceChip(
                  avatar: Icon(_moods[i].icono, size: 18),
                  label: Text(_moods[i].nombre),
                  selected: _moodIndex == i,
                  onSelected: (_) => _cambiarMood(i),
                );
              }),
            ),
          ),
          Expanded(
            child: FutureBuilder<Pelicula>(
              future: _futuro,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No se pudo cargar la película.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final p = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          p.posterUrl!,
                          height: 420,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.titulo,
                                style:
                                    Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Text(p.puntuacion.toStringAsFixed(1)),
                                  const SizedBox(width: 16),
                                  Text(p.fecha),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                p.sinopsis.isEmpty
                                    ? 'Sin sinopsis disponible.'
                                    : p.sinopsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: _buscar,
              icon: const Icon(Icons.casino),
              label: const Text('Otra película'),
            ),
          ),
        ],
      ),
    );
  }
}