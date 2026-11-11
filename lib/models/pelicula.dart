class Pelicula {
  final int id;
  final String titulo;
  final String sinopsis;
  final String? posterPath;
  final double puntuacion;
  final String fecha;

  const Pelicula({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.posterPath,
    required this.puntuacion,
    required this.fecha,
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      id: json['id'] as int,
      titulo: (json['title'] ?? 'Sin título') as String,
      sinopsis: (json['overview'] ?? '') as String,
      posterPath: json['poster_path'] as String?,
      puntuacion: ((json['vote_average'] ?? 0) as num).toDouble(),
      fecha: (json['release_date'] ?? '') as String,
    );
  }

  String? get posterUrl =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/w500$posterPath';
}