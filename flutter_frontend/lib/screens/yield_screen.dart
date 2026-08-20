import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/prediction_form.dart';

/// Mirrors Yield.jsx
class YieldScreen extends StatelessWidget {
  const YieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fields = <PfFormField>[
      const PfFormField(
          name: 'Rainfall_mm',
          label: 'Rainfall (mm)',
          type: 'number',
          placeholder: 'e.g. 120'),
      const PfFormField(
          name: 'Temperature_Celsius',
          label: 'Temperature (°C)',
          type: 'number',
          placeholder: 'e.g. 30'),
      const PfFormField(
          name: 'Days_to_Harvest',
          label: 'Days to Harvest',
          type: 'number',
          placeholder: 'e.g. 90'),
      const PfFormField(
        name: 'Region',
        label: 'Region',
        type: 'select',
        options: ['North', 'South', 'East', 'West', 'Central'],
      ),
      const PfFormField(
        name: 'Soil_Type',
        label: 'Soil Type',
        type: 'select',
        options: ['Clay', 'Sandy', 'Loam', 'Silt', 'Peaty', 'Chalky', 'Black'],
      ),
      const PfFormField(
        name: 'Crop',
        label: 'Crop',
        type: 'select',
        options: [
          'Wheat', 'Rice', 'Maize', 'Barley', 'Cotton',
          'Sugarcane', 'Potato', 'Tomato', 'Onion', 'Soybean',
        ],
      ),
      const PfFormField(
        name: 'Weather_Condition',
        label: 'Weather Condition',
        type: 'select',
        options: ['Sunny', 'Rainy', 'Cloudy', 'Stormy'],
      ),
      const PfFormField(
        name: 'Fertilizer_Used',
        label: 'Fertilizer Used?',
        type: 'select',
        options: ['True', 'False'],
      ),
      const PfFormField(
        name: 'Irrigation_Used',
        label: 'Irrigation Used?',
        type: 'select',
        options: ['True', 'False'],
      ),
    ];

    return PredictionForm(
      title: '🌾 Crop Yield Prediction',
      fields: fields,
      onSubmit: ApiService.predictYield,
      resultKey: 'predicted_yield',
      unit: 'kg/ha',
    );
  }
}
