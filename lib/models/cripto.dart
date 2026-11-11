class Cripto {
  final String id;
  final String nombre;
  final String simbolo;
  final int decimales;
  final double precio;

  const Cripto({
    required this.id,
    required this.nombre,
    required this.simbolo,
    required this.decimales,
    required this.precio,
  });

  double fraccionPara(double dolares) {
    if (precio <= 0) return 0;
    return dolares / precio;
  }
}