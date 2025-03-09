import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/photo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotoRepository {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/photos';
  static const int photosPerPage = 50;

  Future<List<Photo>> fetchPhotos(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?_page=$page&_limit=$photosPerPage'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching photos: $e');
    }
  }
}

// Riverpod provider for the repository
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepository();
});
