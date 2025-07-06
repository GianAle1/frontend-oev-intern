// presentation/providers/video_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider simple para manejar videos locales/URLs directas
final videoUrlProvider = FutureProvider.family<String, String>((ref, videoKey) async {
  // Si ya es una URL completa, la devolvemos directamente
  if (videoKey.startsWith('http://') || videoKey.startsWith('https://')) {
    return videoKey;
  }

  // Si es una clave local, construimos la URL
  // Puedes cambiar esta base URL por tu servidor local
  const String baseVideoUrl = 'http://localhost:8080/videos/';
  return '$baseVideoUrl$videoKey';
});

// Provider para URLs de prueba (puedes usar estos para testing)
final testVideoUrlProvider = Provider<String>((ref) {
  // URL de video de prueba - puedes cambiarla por cualquier video público
  return 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
});