import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/prediction_form.dart';

/// Mirrors Crop.jsx — all 36 Indian states + soil/nutrient inputs
class CropScreen extends StatelessWidget {
  const CropScreen({super.key});

  static const _indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
    'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
    'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
    'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Andaman and Nicobar Islands', 'Chandigarh', 'Dadra and Nagar Haveli',
    'Daman and Diu', 'Delhi', 'Lakshadweep', 'Puducherry',
    'Jammu and Kashmir', 'Ladakh',
  ];

  @override
  Widget build(BuildContext context) {
    final fields = <PfFormField>[
      const PfFormField(name: 'N', label: 'Nitrogen (N)', type: 'number', placeholder: 'e.g. 90'),
      const PfFormField(name: 'P', label: 'Phosphorus (P)', type: 'number', placeholder: 'e.g. 42'),
      const PfFormField(name: 'K', label: 'Potassium (K)', type: 'number', placeholder: 'e.g. 43'),
      const PfFormField(name: 'temperature', label: 'Temperature (°C)', type: 'number', placeholder: 'e.g. 20.8'),
      const PfFormField(name: 'humidity', label: 'Humidity (%)', type: 'number', placeholder: 'e.g. 82'),
      const PfFormField(name: 'ph', label: 'Soil pH', type: 'number', placeholder: 'e.g. 6.5'),
      const PfFormField(name: 'rainfall', label: 'Rainfall (mm)', type: 'number', placeholder: 'e.g. 202'),
      PfFormField(name: 'state', label: 'State', type: 'select', options: _indianStates),
    ];

    return PredictionForm(
      title: '🌱 Crop Recommendation',
      fields: fields,
      onSubmit: ApiService.recommendCrop,
      resultKey: 'recommended_crop',
    );
  }
}
