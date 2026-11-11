import 'package:flutter/material.dart';

import '../models/clima.dart';
import '../services/clima_service.dart';
import '../services/ubicacion_service.dart';

class Reto3Page extends StatefulWidget {
  const Reto3Page({super.key});

  @override
  State<Reto3Page> createState() => _Reto3PageState();
}

class _Reto3PageState extends State<Reto3Page> {
  static const String _ciudadPorDefecto = 'Dolores Hidalgo';

  final ClimaService _clima = ClimaService();
  final UbicacionService _ubicacion = UbicacionService();
  final TextEditingController _controlador = TextEditingController();

  late Future<Clima> _futuro;
  String? _aviso;

  @override
  void initState() {
    super.initState();
    _futuro = _climaPorUbicacion();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<Clima> _climaPorUbicacion() async {
    _aviso = null;

    try {
      final posicion = await _ubicacion.obtener();
      return await _clima.porCoordenadas(posicion.latitude, posicion.longitude);
    } catch (e) {
      _aviso = e.toString().replaceFirst('Exception: ', '');
      return _clima.porCiudad(_ciudadPorDefecto);
    }
  }

  void _usarUbicacion() {
    setState(() {
      _futuro = _climaPorUbicacion();
    });
  }

  void _buscarCiudad() {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _aviso = null;
      _futuro = _clima.porCiudad(texto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controlador,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscarCiudad(),
              decoration: InputDecoration(
                labelText: 'Buscar ciudad',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarCiudad,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _usarUbicacion,
                icon: const Icon(Icons.my_location),
                label: const Text('Usar mi ubicación'),
              ),
            ),
            Expanded(
              child: FutureBuilder<Clima>(
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

                  final c = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_aviso != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            '$_aviso. Mostrando $_ciudadPorDefecto.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      Text(
                        c.ciudad,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(c.region),
                      Image.network(c.iconoUrl, width: 128, height: 128),
                      Text(
                        '${c.temperatura.round()}°',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        c.descripcion,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _Dato(
                            icono: Icons.thermostat,
                            etiqueta: 'Sensación',
                            valor: '${c.sensacion.round()}°',
                          ),
                          _Dato(
                            icono: Icons.water_drop,
                            etiqueta: 'Humedad',
                            valor: '${c.humedad}%',
                          ),
                          _Dato(
                            icono: Icons.air,
                            etiqueta: 'Viento',
                            valor: '${c.viento.round()} km/h',
                          ),
                        ],
                      ),
                    ],
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

class _Dato extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _Dato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono),
        const SizedBox(height: 4),
        Text(valor, style: Theme.of(context).textTheme.titleMedium),
        Text(etiqueta, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}