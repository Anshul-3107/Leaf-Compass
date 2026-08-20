import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

/// Central API service — mirrors frontend/src/services/api.js
///
/// Base URL note:
///   Android emulator → http://10.0.2.2:8000
///   iOS simulator    → http://localhost:8000
///   Physical device  → http://[your-machine-IP]:8000
class ApiService {
  // Change this to your machine's local IP when testing on a physical device.
  static const String baseUrl = 'http://10.0.2.2:8000';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // ── Health Check ──────────────────────────────────────────────────────────
  static Future<Response> checkServer() => _dio.get('/');

  // ── Disease Detection (multipart image upload) ────────────────────────────
  /// Mirrors: predictDisease(formData) => API.post('/predict-disease', formData)
  static Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    final uri = Uri.parse('$baseUrl/predict-disease');
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send().timeout(
          const Duration(seconds: 30),
        );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
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
