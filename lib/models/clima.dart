class Clima {
  final String ciudad;
  final String region;
  final double temperatura;
  final double sensacion;
  final int humedad;
  final double viento;
  final String descripcion;
  final String iconoUrl;

  const Clima({
    required this.ciudad,
    required this.region,
    required this.temperatura,
    required this.sensacion,
    required this.humedad,
    required this.viento,
    required this.descripcion,
    required this.iconoUrl,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    final lugar = json['location'] as Map<String, dynamic>;
    final actual = json['current'] as Map<String, dynamic>;
    final condicion = actual['condition'] as Map<String, dynamic>;
    final icono = (condicion['icon'] as String).replaceAll('64x64', '128x128');

    return Clima(
      ciudad: lugar['name'] as String,
      region: lugar['region'] as String,
      temperatura: (actual['temp_c'] as num).toDouble(),
      sensacion: (actual['feelslike_c'] as num).toDouble(),
      humedad: (actual['humidity'] as num).toInt(),
      viento: (actual['wind_kph'] as num).toDouble(),
      descripcion: condicion['text'] as String,
      iconoUrl: 'https:$icono',
    );
  }
}