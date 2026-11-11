import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cripto.dart';

class _Moneda {
  final String id;
  final String nombre;
  final String simbolo;
  final int decimales;

  const _Moneda(this.id, this.nombre, this.simbolo, this.decimales);
}

class CoinGeckoService {
  static const List<_Moneda> _monedas = [
    _Moneda('bitcoin', 'Bitcoin', 'BTC', 8),
    _Moneda('ethereum', 'Ethereum', 'ETH', 6),
    _Moneda('solana', 'Solana', 'SOL', 4),
  ];

  Future<List<Cripto>> precios() async {
    final ids = _monedas.map((m) => m.id).join(',');

    final uri = Uri.https('api.coingecko.com', '/api/v3/simple/price', {
      'ids': ids,
      'vs_currencies': 'usd',
    });

    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 429) {
      throw Exception('Demasiadas consultas, espera un minuto e intenta de nuevo');
    }

    if (respuesta.statusCode != 200) {
      throw Exception('Error del servidor: ${respuesta.statusCode}');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;

    return _monedas.map((m) {
      final entrada = datos[m.id] as Map<String, dynamic>?;
      final precio = ((entrada?['usd'] ?? 0) as num).toDouble();

      return Cripto(
        id: m.id,
        nombre: m.nombre,
        simbolo: m.simbolo,
        decimales: m.decimales,
        precio: precio,
      );
    }).toList();
  }
}