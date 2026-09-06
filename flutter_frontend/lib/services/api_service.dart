
import 'package:dio/dio.dart';
import 'dart:io';

/// Central API service — mirrors frontend/src/services/api.js
///
/// Base URL is configured at build/run time via --dart-define:
///
///   Android emulator (default, no flag needed):
///     flutter run
///
///   Physical device (replace with your machine's LAN IP):
///     flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000
///
///   Web (local dev):
///     flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
///
///   Release build pointing at Render backend:
///     flutter build apk  --dart-define=API_BASE_URL=https://LeafCompass.onrender.com
///     flutter build web  --dart-define=API_BASE_URL=https://LeafCompass.onrender.com
///
///   iOS simulator:
///     flutter run --dart-define=API_BASE_URL=http://localhost:8000
class ApiService {
  /// Resolved at compile time from --dart-define=API_BASE_URL=...
  /// Falls back to the Android-emulator loopback alias when no flag is supplied.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // ── Health Check ──────────────────────────────────────────────────────────
  static Future<Response> checkServer() => _dio.get('/');

  // ── Disease Detection (multipart image upload) ────────────────────────────
  /// Mirrors: predictDisease(formData) => API.post('/predict-disease', formData)
  static Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
    });

    final response = await _dio.post('/predict-disease', data: formData);

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    }
    throw Exception('Disease prediction failed: ${response.statusCode}');
  }

  // ── Yield Prediction ──────────────────────────────────────────────────────
  /// Mirrors: predictYield(data) => API.post('/predict-yield', data)
  static Future<Response> predictYield(Map<String, dynamic> data) =>
      _dio.post('/predict-yield', data: data);

  // ── Crop Recommendation ───────────────────────────────────────────────────
  /// Mirrors: recommendCrop(data) => API.post('/recommend-crop', data)
  static Future<Response> recommendCrop(Map<String, dynamic> data) =>
      _dio.post('/recommend-crop', data: data);

  // ── Fertilizer Recommendation ─────────────────────────────────────────────
  /// Mirrors: recommendFertilizer(data) => API.post('/recommend-fertilizer', data)
  static Future<Response> recommendFertilizer(Map<String, dynamic> data) =>
      _dio.post('/recommend-fertilizer', data: data);

  // ── AI Chat ───────────────────────────────────────────────────────────────
  /// Mirrors: chatWithBot(message) => API.post('/chat', { message })
  static Future<Response> chatWithBot(String message) =>
      _dio.post('/chat', data: {'message': message});
}
