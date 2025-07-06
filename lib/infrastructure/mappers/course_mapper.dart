import 'package:oev_mobile_app/domain/entities/course/course_model.dart';

class CourseMapper {
  static Course userJsonToEntity(Map<String, dynamic> json) {
    // Función para validar y limpiar URLs
    String? _cleanImageUrl(String? url) {
      if (url == null || url.isEmpty) return null;

      // Remover espacios en blanco
      url = url.trim();

      // Validar que la URL comience con http o https
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        print('URL inválida detectada: $url');
        return null;
      }

      return url;
    }

    // URL por defecto como fallback
    const String defaultImageUrl = 'https://www.acacia.edu/wp-content/uploads/2023/06/acacia-blog-image-1024x578.jpg';

    // Limpiar y validar la URL de imagen
    String? cleanImageUrl = _cleanImageUrl(json['imageUrl']);

    // Debug: imprimir información de la URL
    print('Original imageUrl: ${json['imageUrl']}');
    print('Cleaned imageUrl: $cleanImageUrl');

    return Course(
      id: json['id'],
      name: json['name'] ?? 'Curso sin nombre',
      description: json['description'] ?? '',
      benefits: json['benefits'] ?? '',
      targetAudience: json['targetAudience'] ?? '',
      imageUrl: cleanImageUrl ?? defaultImageUrl,
      category: json['category'] ?? 'No category',
      level: json['level'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      duration: json['duration'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      favorite: json['favorite'] ?? 0,
      status: json['status'] ?? '',
      creationDate: json['creationDate'] != null
          ? DateTime.parse(json['creationDate'])
          : DateTime.now(),
      lastUpdate: json['lastUpdate'] != null
          ? DateTime.parse(json['lastUpdate'])
          : DateTime.now(),
      userId: json['userId'] ?? 0,
      instructorName: json['instructorName'] ?? 'Instructor Name',
    );
  }

  // Método adicional para validar URLs
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url.trim());
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}