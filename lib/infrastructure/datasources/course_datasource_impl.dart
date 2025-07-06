import 'package:dio/dio.dart';
import 'package:oev_mobile_app/config/constants/environment.dart';
import 'package:oev_mobile_app/domain/datasources/course_datasource.dart';
import 'package:oev_mobile_app/domain/entities/course/course_model.dart';
import 'package:oev_mobile_app/domain/entities/dto/course_enrolled.dart';
import 'package:oev_mobile_app/domain/entities/dto/request/course_dto.dart';
import 'package:oev_mobile_app/domain/entities/lesson/lesson_progress_model.dart';
import 'package:oev_mobile_app/infrastructure/mappers/course_mapper.dart';

class CourseDatasourceImpl implements CourseDatasource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  @override
  Future<List<Course>> getCourses() async {
    try {
      print('Obteniendo cursos desde: ${Environment.apiUrl}/course/findAll');

      final response = await _dio.get('/course/findAll');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // Debug: imprimir la respuesta completa
        print('Respuesta del servidor: $data');

        // Debug: verificar cada curso individualmente
        for (var courseJson in data) {
          print('Curso ID: ${courseJson['id']}');
          print('Nombre: ${courseJson['name']}');
          print('ImageUrl: ${courseJson['imageUrl']}');
          print('---');
        }

        final courses = data.map((json) => CourseMapper.userJsonToEntity(json)).toList();

        // Debug: verificar cursos mapeados
        for (var course in courses) {
          print('Curso mapeado - ID: ${course.id}, ImageUrl: ${course.imageUrl}');
        }

        return courses;
      } else {
        print('Error en respuesta: ${response.statusCode}');
        throw Exception('Error al cargar los cursos - Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getCourses: $e');
      if (e is DioException) {
        print('Dio Error Type: ${e.type}');
        print('Dio Error Message: ${e.message}');
        print('Dio Error Response: ${e.response?.data}');
      }
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<List<CourseEnrolled>> getEnrolledCourses(int userId) async {
    try {
      print('Obteniendo cursos inscritos para usuario: $userId');

      final response = await _dio.get('/enrollment/findAllByUserId/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // Debug: imprimir información de cursos inscritos
        print('Cursos inscritos encontrados: ${data.length}');
        for (var enrolledJson in data) {
          print('Curso inscrito - ID: ${enrolledJson['courseId']}');
          print('ImageUrl: ${enrolledJson['courseImageUrl']}');
          print('---');
        }

        return data.map((json) => CourseEnrolled.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los cursos inscritos');
      }
    } catch (e) {
      print('Error en getEnrolledCourses: $e');
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<Course> getCourseById(int courseId) async {
    try {
      print('Obteniendo curso por ID: $courseId');

      final response = await _dio.get('/course/findCourse/$courseId');

      if (response.statusCode == 200) {
        print('Curso encontrado: ${response.data}');
        print('ImageUrl del curso: ${response.data['imageUrl']}');

        return CourseMapper.userJsonToEntity(response.data);
      } else {
        throw Exception('Error al obtener el curso con ID $courseId');
      }
    } catch (e) {
      print('Error en getCourseById: $e');
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<List<Course>> getRecommendedCourses() async {
    try {
      print('Obteniendo cursos recomendados...');

      // Get all courses first
      final allCourses = await getCourses();

      // Get enrollment counts for each course
      final coursesWithEnrollments = await Future.wait(
        allCourses.map((course) async {
          final enrollmentCount = await getEnrolledUsersCount(course.id);
          return MapEntry(course, enrollmentCount);
        }),
      );

      // Sort courses by enrollment count
      coursesWithEnrollments.sort((a, b) => b.value.compareTo(a.value));

      // Return sorted courses
      final recommendedCourses = coursesWithEnrollments.map((entry) => entry.key).toList();

      print('Cursos recomendados ordenados: ${recommendedCourses.length}');
      for (var course in recommendedCourses.take(5)) {
        print('Curso recomendado - ${course.name}, Students: ${course.totalStudents}, ImageUrl: ${course.imageUrl}');
      }

      return recommendedCourses;
    } catch (e) {
      print('Error en getRecommendedCourses: $e');
      throw Exception('Error al obtener cursos recomendados: $e');
    }
  }

  // Resto de métodos sin cambios...
  @override
  Future<Course> addCourse(int userId, CourseRequestDTO courseRequestDTO) async {
    try {
      final response = await _dio.post(
        '/course/create/$userId',
        data: courseRequestDTO.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CourseMapper.userJsonToEntity(response.data);
      } else {
        throw Exception('Error al agregar el curso');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<List<Course>> getCoursesPublishedByInstructor(int userId) async {
    try {
      final response = await _dio.get('/course/findAllByUserId/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CourseMapper.userJsonToEntity(json)).toList();
      } else {
        throw Exception('Error al cargar los cursos publicados por el instructor');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<List<LessonProgress>> getLessonsByUserIdAndCourseId(int userId, int courseId) async {
    try {
      final response = await _dio.get('/user-lesson-progress/user/$userId/course/$courseId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => LessonProgress.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las lecciones');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<void> deleteCourse(int courseId) async {
    try {
      final response = await _dio.delete('/course/delete/$courseId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar el curso');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<int> getEnrolledUsersCount(int courseId) async {
    try {
      final response = await _dio.get('/enrollment/findEnrolledUsersByCourseId/$courseId');
      if (response.statusCode == 200) {
        final List<dynamic> enrolledUsers = response.data;
        return enrolledUsers.length;
      } else {
        throw Exception('Error al obtener el número de usuarios inscritos');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }
}