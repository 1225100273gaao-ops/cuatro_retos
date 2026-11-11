import 'package:flutter/material.dart';

class _Filtro {
  final String nombre;
  final String? valor;

  const _Filtro(this.nombre, this.valor);
}

class Reto2Page extends StatefulWidget {
  const Reto2Page({super.key});

  @override
  State<Reto2Page> createState() => _Reto2PageState();
}

class _Reto2PageState extends State<Reto2Page> {
  static const List<_Filtro> _filtros = [
    _Filtro('Normal', null),
    _Filtro('Blanco y negro', 'mono'),
    _Filtro('Sepia', 'sepia'),
    _Filtro('Desenfoque', 'blur'),
    _Filtro('Negativo', 'negate'),
    _Filtro('Pintura', 'paint'),
  ];

  final TextEditingController _controlador = TextEditingController();
  String _texto = '';
  int _filtroIndex = 0;
  int _semilla = DateTime.now().millisecondsSinceEpoch;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Uri _construirUrl() {
    final parametros = <String, String>{
      'fontSize': '40',
      'fontColor': 'white',
      'semilla': '$_semilla',
    };

    final filtro = _filtros[_filtroIndex].valor;
    if (filtro != null) {
      parametros['filter'] = filtro;
    }

    final segmentos = _texto.trim().isEmpty
        ? ['cat']
        : ['cat', 'says', _texto.trim()];

    return Uri(
      scheme: 'https',
      host: 'cataas.com',
      pathSegments: segmentos,
      queryParameters: parametros,
    );
  }

  void _aplicarTexto() {
    FocusScope.of(context).unfocus();
    setState(() {
      _texto = _controlador.text;
    });
  }

  void _otroGato() {
    setState(() {
      _semilla = DateTime.now().millisecondsSinceEpoch;
    });
  }

  @override
  Widget build(BuildContext context) {
    final url = _construirUrl().toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Memes de gatos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controlador,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _aplicarTexto(),
              decoration: InputDecoration(
                labelText: 'Escribe tu frase',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _aplicarTexto,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filtros.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  return ChoiceChip(
                    label: Text(_filtros[i].nombre),
                    selected: _filtroIndex == i,
                    onSelected: (_) => setState(() => _filtroIndex = i),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  url,
                  key: ValueKey(url),
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progreso) {
                    if (progreso == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stack) {
                    return const Center(
                      child: Text('No se pudo cargar el gato'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _otroGato,
              icon: const Icon(Icons.pets),
              label: const Text('Otro gato'),
            ),
          ],
        ),
      ),
    );
  }
}