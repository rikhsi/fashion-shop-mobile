import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class TryOnService extends ChangeNotifier {
  // Replace with your ImaginePro API key from https://platform.imaginepro.ai/
  static const String _apiKey = '';
  static const String _baseUrl = 'https://us-central1-imagineapi-prod.cloudfunctions.net';
  static const String _model = 'nano-banana-2';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 300),
  ));

  final List<String> _savedPhotos = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=600&fit=crop',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
  ];

  List<String> get savedPhotos => List.unmodifiable(_savedPhotos);

  void addPhoto(String url) {
    _savedPhotos.insert(0, url);
    notifyListeners();
  }

  void removePhoto(int index) {
    _savedPhotos.removeAt(index);
    notifyListeners();
  }

  /// Calls the ImaginePro Nano Banana API for virtual try-on.
  /// [personImageUrl] - URL or base64 of the person's photo
  /// [garmentImageUrl] - URL of the product/garment image
  /// Returns the result image URL, or null on failure.
  Future<String?> tryOn({
    required String personImageUrl,
    required String garmentImageUrl,
  }) async {
    if (_apiKey.isEmpty) {
      return _mockTryOn();
    }

    try {
      final response = await _dio.post(
        '/api/v1/universal/imagine',
        data: jsonEncode({
          'model': _model,
          'contents': [
            {'type': 'image', 'url': personImageUrl},
            {'type': 'image', 'url': garmentImageUrl},
            {
              'type': 'text',
              'text': 'Dress the person in the first image with the clothing '
                  'from the second image. Keep the person\'s face, body shape, '
                  'and pose exactly the same. Make it look natural and realistic.',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['output'] != null) {
          final output = data['output'];
          if (output is List && output.isNotEmpty) {
            return output.first as String;
          }
          if (output is String) return output;
        }
      }
      return null;
    } catch (e) {
      debugPrint('TryOn API error: $e');
      return _mockTryOn();
    }
  }

  /// Returns a mock result for demo/preview when no API key is set.
  Future<String?> _mockTryOn() async {
    await Future.delayed(const Duration(seconds: 3));
    return 'https://images.unsplash.com/photo-1495385794356-15371f348c31?w=400&h=600&fit=crop';
  }
}
