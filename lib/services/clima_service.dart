import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/clima.dart';

class ClimaService {
  static const String _apiKey = 'c00ba8b043674cbabf915417261111';

  Future<Clima> porCoordenadas(double latitud, double longitud) {
    return _consultar('$latitud,$longitud');
  }

  Future<Clima> porCiudad(String ciudad) {
    return _consultar(ciudad);
  }

  Future<Clima> _consultar(String consulta) async {
    final uri = Uri.https('api.weatherapi.com', '/v1/current.json', {
      'key': _apiKey,
      'q': consulta,
      'lang': 'es',
    });

    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 400) {
      throw Exception('No encontré esa ciudad');
    }

    if (respuesta.statusCode != 200) {
      throw Exception('Error del servidor: ${respuesta.statusCode}');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    return Clima.fromJson(datos);
  }
}