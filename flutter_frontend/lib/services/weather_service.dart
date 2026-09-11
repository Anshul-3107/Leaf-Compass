import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_data.dart';

/// Service for fetching live weather data.
///
/// Flow: GPS coordinates → Open-Meteo (weather) + Nominatim (reverse geocode)
///
/// All methods are static. No API keys required.
class WeatherService {
  WeatherService._();

  // Separate Dio instance for external APIs (not the backend)
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // ── Public API ─────────────────────────────────────────────────────────

  /// Full pipeline: get GPS → fetch weather + geocode in parallel.
  /// Throws [LocationServiceDisabledException], [LocationPermissionException],
  /// or generic [Exception] on failure.
  static Future<WeatherData> fetchCurrentWeather() async {
    final position = await _getCurrentPosition();
    final lat = position.latitude;
    final lon = position.longitude;

    // Fire both requests in parallel
    final results = await Future.wait([
      _fetchWeather(lat, lon),
      _reverseGeocode(lat, lon),
    ]);

    final weatherMap = results[0] as Map<String, dynamic>;
    final locationName = results[1] as String;

    return _parseWeather(weatherMap, locationName);
  }

  // ── Location ───────────────────────────────────────────────────────────

  /// Returns the current device position.
  /// Throws typed exceptions for each failure mode.
  static Future<Position> _getCurrentPosition() async {
    // 1. Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    // 2. Check / request permission
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionException('denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionException('deniedForever');
    }

    // 3. Get position (whileInUse or always)
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low, // City-level is fine for weather
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  // ── Weather API ────────────────────────────────────────────────────────

  /// Calls Open-Meteo forecast API for current conditions.
  static Future<Map<String, dynamic>> _fetchWeather(
      double lat, double lon) async {
    final response = await _dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'current':
            'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
        'timezone': 'auto',
      },
    );
    return response.data as Map<String, dynamic>;
  }

  // ── Reverse Geocoding ──────────────────────────────────────────────────

  /// Calls Nominatim to convert coordinates into a readable location name.
  static Future<String> _reverseGeocode(double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'format': 'jsonv2',
          'accept-language': 'en',
        },
        options: Options(
          headers: {'User-Agent': 'LeafCompass/1.0'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final address = data['address'] as Map<String, dynamic>?;

      if (address != null) {
        // Try city first, then town, then state
        final city = address['city'] as String? ??
            address['town'] as String? ??
            address['village'] as String? ??
            address['state'] as String? ??
            '';
        final country = address['country'] as String? ?? '';

        if (city.isNotEmpty && country.isNotEmpty) {
          return '$city, $country';
        }
        if (city.isNotEmpty) return city;
        if (country.isNotEmpty) return country;
      }

      // Fallback: use display_name and take first two parts
      final displayName = data['display_name'] as String? ?? '';
      if (displayName.isNotEmpty) {
        final parts = displayName.split(', ');
        if (parts.length >= 2) {
          return '${parts[0]}, ${parts[1]}';
        }
        return parts[0];
      }

      return 'Unknown Location';
    } catch (_) {
      // Geocoding failure is non-critical — show coords as fallback
      return '${lat.toStringAsFixed(2)}°, ${lon.toStringAsFixed(2)}°';
    }
  }

  // ── Parsing ────────────────────────────────────────────────────────────

  static WeatherData _parseWeather(
      Map<String, dynamic> data, String locationName) {
    final current = data['current'] as Map<String, dynamic>;

    final temp = (current['temperature_2m'] as num).round();
    final humidity = (current['relative_humidity_2m'] as num).round();
    final wind = (current['wind_speed_10m'] as num).round();
    final weatherCode = (current['weather_code'] as num).toInt();

    final conditionInfo = _mapWeatherCode(weatherCode);

    return WeatherData(
      temperature: temp,
      condition: conditionInfo.label,
      humidity: humidity,
      windSpeed: wind,
      location: locationName,
      weatherIcon: conditionInfo.icon,
    );
  }

  // ── WMO Weather Code Mapping ───────────────────────────────────────────

  static ({String label, IconData icon}) _mapWeatherCode(int code) {
    return switch (code) {
      0 => (label: 'Clear sky', icon: Icons.wb_sunny),
      1 => (label: 'Mainly clear', icon: Icons.wb_sunny),
      2 => (label: 'Partly cloudy', icon: Icons.cloud_queue),
      3 => (label: 'Overcast', icon: Icons.cloud),
      45 || 48 => (label: 'Foggy', icon: Icons.foggy),
      51 || 53 || 55 => (label: 'Drizzle', icon: Icons.grain),
      56 || 57 => (label: 'Freezing drizzle', icon: Icons.ac_unit),
      61 || 63 || 65 => (label: 'Rain', icon: Icons.water_drop),
      66 || 67 => (label: 'Freezing rain', icon: Icons.ac_unit),
      71 || 73 || 75 => (label: 'Snow', icon: Icons.ac_unit),
      77 => (label: 'Snow grains', icon: Icons.ac_unit),
      80 || 81 || 82 => (label: 'Rain showers', icon: Icons.umbrella),
      85 || 86 => (label: 'Snow showers', icon: Icons.ac_unit),
      95 => (label: 'Thunderstorm', icon: Icons.thunderstorm),
      96 || 99 => (label: 'Thunderstorm', icon: Icons.thunderstorm),
      _ => (label: 'Unknown', icon: Icons.help_outline),
    };
  }
}

// ── Custom Exceptions ──────────────────────────────────────────────────────

/// Thrown when location permission is denied or permanently denied.
class LocationPermissionException implements Exception {
  final String status; // 'denied' or 'deniedForever'
  LocationPermissionException(this.status);

  bool get isPermanent => status == 'deniedForever';

  @override
  String toString() => isPermanent
      ? 'Location permission permanently denied.'
      : 'Location permission denied.';
}
