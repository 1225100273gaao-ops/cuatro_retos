import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/pelicula.dart';

class TmdbService {
  static const String _apiKey = '4ce3e1f9f693cfb93e74521398afe23d';
  static const String _host = 'api.themoviedb.org';

  final Random _random = Random();

  Future<List<Pelicula>> porGenero(int generoId) async {
    final pagina = _random.nextInt(5) + 1;

    final uri = Uri.https(_host, '/3/discover/movie', {
      'api_key': _apiKey,
      'language': 'es-MX',
      'with_genres': '$generoId',
      'sort_by': 'popularity.desc',
      'page': '$pagina',
    });

    final respuesta = await http.get(uri);

    if (respuesta.statusCode != 200) {
      throw Exception('Error del servidor: ${respuesta.statusCode}');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final lista = datos['results'] as List<dynamic>;

    return lista
        .map((e) => Pelicula.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Pelicula> alAzar(int generoId) async {
    final lista = await porGenero(generoId);
    final conPoster = lista.where((p) => p.posterPath != null).toList();

    if (conPoster.isEmpty) {
      throw Exception('No se encontraron películas');
    }

    return conPoster[_random.nextInt(conPoster.length)];
  }
}