import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/api_service.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/screen_header.dart';
import '../widgets/error_banner.dart';
import '../widgets/result_card.dart';

/// Mirrors Disease.jsx
/// Allows picking a leaf image and detecting plant disease via /predict-disease
class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({super.key});

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  File? _image;
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
        source: source, imageQuality: 90, maxWidth: 800);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _result = null;
        _error = null;
      });
    }
  }

  Future<void> _analyze() async {
    if (_image == null) return;
    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });
    try {
      final data = await ApiService.predictDisease(_image!);
      if (data.containsKey('error')) {
        setState(() => _error = data['error'] as String);
      } else {
        setState(() => _result = data);
      }
    } catch (e) {
      setState(() => _error = 'Prediction failed. Please try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Screen Header ──
            ScreenHeader(
              icon: Icons.biotech,
              title: 'Plant Disease Detection',
              description:
                  'Upload or capture a photo of a leaf to instantly identify diseases using AI-powered analysis.',
              accentColor: context.themeColors.accentDisease,
            ),

            // ── Image Upload Area ──
            Material(
              color: context.themeColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                onTap: () => _showImageSourceSheet(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(
                      color: _image != null
                          ? context.themeColors.primary
                          : context.themeColors.surfaceDim,
                      width: _image != null ? 2 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _image != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_image!, fit: BoxFit.cover),
                            Positioned(
                              top: AppSpacing.sm,
                              right: AppSpacing.sm,
                              child: Material(
                                color: Colors.black54,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusFull),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusFull),
                                  onTap: () => setState(() {
                                    _image = null;
                                    _result = null;
                                    _error = null;
                                  }),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: context.themeColors.accentDiseaseLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.cloud_upload_outlined,
                                  size: 36, color: context.themeColors.accentDisease),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text('Tap to upload a leaf photo',
                                style: context.bodyMedium),
                            const SizedBox(height: AppSpacing.xs),
                            Text('Gallery or Camera',
                                style: context.labelMedium),
                          ],
                        ),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: AppSpacing.xl),

            // ── Analyze Button ──
            ElevatedButton.icon(
              onPressed: (_loading || _image == null) ? null : _analyze,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.search, size: 20),
              label: Text(_loading ? 'Scanning...' : 'Analyze Plant'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: context.themeColors.accentDisease,
              ),
            ).animate().fadeIn(delay: 200.ms),

            // ── Error ──
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ErrorBanner(
                message: _error!,
                onDismiss: () => setState(() => _error = null),
              ),
            ],

            // ── Result ──
            if (_result != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              ResultCard(
                label: 'ANALYSIS RESULT',
                displayValue: _result!['class'] as String? ?? 'Unknown',
                confidence: _result!['confidence'] as double? ?? 0.0,
                accentColor: context.themeColors.accentDisease,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.themeColors.surfaceDim,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Choose Image Source', style: context.titleMedium),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SourceOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _SourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceOption(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.themeColors.primaryContainer,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
          child: Column(
            children: [
              Icon(icon, color: context.themeColors.primary, size: 30),
              const SizedBox(height: AppSpacing.sm),
              Text(label, style: context.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
