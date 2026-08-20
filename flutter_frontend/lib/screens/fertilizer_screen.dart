import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/prediction_form.dart';

/// Mirrors Fertilizer.jsx
class FertilizerScreen extends StatelessWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fields = <PfFormField>[
      const PfFormField(name: 'Temperature', label: 'Temperature (°C)', type: 'number'),
      const PfFormField(name: 'Humidity', label: 'Humidity (%)', type: 'number'),
      const PfFormField(name: 'Moisture', label: 'Soil Moisture', type: 'number'),
      const PfFormField(
        name: 'Soil_Type', label: 'Soil Type', type: 'select',
        options: ['Sandy', 'Loamy', 'Black', 'Red', 'Clayey'],
      ),
      const PfFormField(
        name: 'Crop_Type', label: 'Crop Type', type: 'select',
        options: [
          'Maize', 'Sugarcane', 'Cotton', 'Tobacco', 'Paddy',
          'Barley', 'Wheat', 'Millets', 'Oil seeds', 'Pulses', 'Ground Nuts',
        ],
      ),
      const PfFormField(name: 'Nitrogen', label: 'Nitrogen (N)', type: 'number'),
      const PfFormField(name: 'Phosphorous', label: 'Phosphorous (P)', type: 'number'),
      const PfFormField(name: 'Potassium', label: 'Potassium (K)', type: 'number'),
    ];

    return PredictionForm(
      title: '🧪 Fertilizer Recommendation',
      fields: fields,
      onSubmit: ApiService.recommendFertilizer,
      resultKey: 'recommended_fertilizer',
    );
  }
}
