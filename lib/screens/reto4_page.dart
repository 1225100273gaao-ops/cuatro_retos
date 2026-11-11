import 'package:flutter/material.dart';

import '../models/cripto.dart';
import '../services/coingecko_service.dart';

class Reto4Page extends StatefulWidget {
  const Reto4Page({super.key});

  @override
  State<Reto4Page> createState() => _Reto4PageState();
}

class _Reto4PageState extends State<Reto4Page> {
  final CoinGeckoService _servicio = CoinGeckoService();
  late Future<List<Cripto>> _futuro;
  double _monto = 0;

  @override
  void initState() {
    super.initState();
    _futuro = _servicio.precios();
  }

  void _actualizar() {
    setState(() {
      _futuro = _servicio.precios();
    });
  }

  void _cambioMonto(String texto) {
    final valor = double.tryParse(texto.replaceAll(',', '.')) ?? 0;
    setState(() {
      _monto = valor < 0 ? 0 : valor;
    });
  }

  String _usd(double valor) {
    final partes = valor.toStringAsFixed(2).split('.');
    final entero = partes[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '\$$entero.${partes[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptomonedas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _actualizar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: _cambioMonto,
              decoration: const InputDecoration(
                labelText: 'Monto en USD',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Cripto>>(
                future: _futuro,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    final mensaje = snapshot.error
                        .toString()
                        .replaceFirst('Exception: ', '');
                    return Center(
                      child: Text(mensaje, textAlign: TextAlign.center),
                    );
                  }

                  final criptos = snapshot.data!;

                  return ListView.builder(
                    itemCount: criptos.length,
                    itemBuilder: (context, index) {
                      final c = criptos[index];
                      final fraccion = c.fraccionPara(_monto);

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text(c.simbolo[0])),
                          title: Text('${c.nombre} (${c.simbolo})'),
                          subtitle: Text('Precio: ${_usd(c.precio)}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                fraccion.toStringAsFixed(c.decimales),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                c.simbolo,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}