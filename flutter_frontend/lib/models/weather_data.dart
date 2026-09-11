import 'package:flutter/material.dart';

/// Data class for current weather conditions fetched from Open-Meteo.
class WeatherData {
  final int temperature;
  final String condition;
  final int humidity;
  final int windSpeed;
  final String location;
  final IconData weatherIcon;

  const WeatherData({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.location,
    required this.weatherIcon,
  });
}
