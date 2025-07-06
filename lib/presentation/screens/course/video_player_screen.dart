// presentation/screens/course/video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oev_mobile_app/domain/entities/dto/course_enrolled.dart';
import 'package:oev_mobile_app/domain/entities/lesson/lesson_model.dart';
import 'package:oev_mobile_app/presentation/providers/video_provider.dart';

class VideoPlayerScreen extends ConsumerWidget {
  final Lesson lesson;
  final CourseEnrolled courseEnrolled;

  const VideoPlayerScreen({
    required this.lesson,
    required this.courseEnrolled,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Por ahora usamos URL de prueba, pero puedes cambiar esto
    // final videoUrlAsync = ref.watch(videoUrlProvider(lesson.videoKey));
    final testVideoUrl = ref.watch(testVideoUrlProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(
          lesson.title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenedor del video
          Container(
            width: double.infinity,
            height: 250,
            color: Colors.black,
            child: Stack(
              children: [
                // Placeholder para el video
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[900],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Video: ${lesson.title}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'VideoKey: ${lesson.videoKey}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Aquí puedes abrir el video en un navegador externo
                          // o implementar tu reproductor de video
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Video URL: $testVideoUrl'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        child: const Text('Reproducir Video'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Información de la lección
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Curso: ${courseEnrolled.courseName}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (lesson.duration != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Duración: ${lesson.duration} minutos',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Marcar como completado
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Lección marcada como completada'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Marcar Completada'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Descargar o ver información adicional
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF242636),
                                title: const Text(
                                  'Información del Video',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Título: ${lesson.title}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Video Key: ${lesson.videoKey}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'URL de prueba: $testVideoUrl',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Más Info'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}