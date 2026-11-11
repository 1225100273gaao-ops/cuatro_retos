import 'package:geolocator/geolocator.dart';

class UbicacionService {
  Future<Position> obtener() async {
    final gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (!gpsActivo) {
      throw Exception('El GPS está desactivado');
    }

    var permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      throw Exception('Permiso de ubicación denegado');
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception('Permiso bloqueado, actívalo en los ajustes del celular');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }
}