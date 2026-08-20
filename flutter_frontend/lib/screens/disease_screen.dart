import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/api_service.dart';
import '../main.dart';

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
        title: const Text('🍃 Disease Detection'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Upload Area
            GestureDetector(
              onTap: () => _showImageSourceSheet(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _image != null ? kAgriGreen : Colors.grey[300]!,
                    width: _image != null ? 2 : 1.5,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _image != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(_image!, fit: BoxFit.cover),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _image = null;
                                _result = null;
                                _error = null;
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined,
                              size: 52, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text('Tap to upload a leaf photo',
                              style: GoogleFonts.inter(
                                  color: Colors.grey[600], fontSize: 14)),
                          const SizedBox(height: 6),
                          Text('Gallery or Camera',
                              style: GoogleFonts.inter(
                                  color: Colors.grey[400], fontSize: 12)),
                        ],
                      ),
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 20),

            // Analyze Button
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
                disabledBackgroundColor: Colors.grey[300],
              ),
            ).animate().fadeIn(delay: 200.ms),

            // Error
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_error!,
                          style: GoogleFonts.inter(
                              color: Colors.red[700], fontSize: 13)),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
            ],

            // Result
            if (_result != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFA5D6A7)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: kAgriGreen, size: 22),
                        const SizedBox(width: 8),
                        Text('Analysis Result',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E7D32))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Disease name
                    Text(
                      _result!['class'] as String? ?? 'Unknown',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 8),
                    // Confidence bar
                    Builder(builder: (ctx) {
                      final conf = (_result!['confidence'] as double? ?? 0.0);
                      return Column(
                        children: [
                          Text(
                            'Confidence: ${(conf * 100).toStringAsFixed(2)}%',
                            style: GoogleFonts.inter(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: conf,
                              minHeight: 8,
                              backgroundColor: Colors.green[100],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  kAgriGreen),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.97, 0.97)),
            ],
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Image Source',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
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
            const SizedBox(height: 16),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: kAgriGreenLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: kAgriGreen, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
