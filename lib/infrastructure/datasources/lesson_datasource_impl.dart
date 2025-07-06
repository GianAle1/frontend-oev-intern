import 'package:dio/dio.dart';
import 'package:oev_mobile_app/domain/datasources/lesson_datasource.dart';
import 'package:oev_mobile_app/domain/entities/lesson/lesson_model.dart';
import '../../config/constants/environment.dart';
import '../../domain/errors/auth_errors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LessonDatasourceImpl implements LessonDataSource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _setAuthHeader() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    } else {
      throw WrongCredentials();
    }
  }

  @override
  Future<List<Lesson>> getLessonsByCourseId(int courseId) async {
    try {
      await _setAuthHeader(); // ✅ volvemos a usar token aquí
      print('Fetching lessons for course ID: $courseId');

      final response = await _dio.get('/api/lesson/findLessonsByCourseId/$courseId');

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Lesson.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las lecciones');
      }
    } catch (e) {
      print('Error in getLessonsByCourseId: $e');
      rethrow;
    }
  }

  @override
  Future<Lesson> createLesson(int courseId, String title, String videoKey) async {
    try {
      await _setAuthHeader();
      final response = await _dio.post(
        '/api/lesson/create/$courseId',
        data: {
          "title": title,
          "videoKey": videoKey,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Lesson.fromJson(response.data);
      } else {
        throw Exception('Error al crear la lección');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) throw ConnectionTimeout();
      throw CustomError('Something went wrong');
    } catch (e) {
      throw CustomError('Something went wrong');
    }
  }

  @override
  Future<void> deleteLessonById(int lessonId) async {
    try {
      await _setAuthHeader();
      await _dio.delete('/api/lesson/delete/$lessonId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) throw ConnectionTimeout();
      throw CustomError('Something went wrong');
    } catch (e) {
      throw CustomError('Something went wrong');
    }
  }
}
