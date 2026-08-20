import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dio/dio.dart';

import '../main.dart';

/// Field definition — mirrors the field objects in PredictionForm.jsx
/// Named PfFormField to avoid collision with Flutter's built-in FormField widget.
class PfFormField {
  final String name;
  final String label;
  final String type; // 'number' | 'select' | 'text'
  final String? placeholder;
  final List<String>? options;

  const PfFormField({
    required this.name,
    required this.label,
    required this.type,
    this.placeholder,
    this.options,
  });
}

/// Reusable prediction form widget — mirrors PredictionForm.jsx
/// Accepts a list of [FormField] definitions, an [onSubmit] API call,
/// the [resultKey] to read from the response, and an optional [unit].
class PredictionForm extends StatefulWidget {
  final String title;
  final List<PfFormField> fields;
  final Future<Response> Function(Map<String, dynamic>) onSubmit;
  final String resultKey;
  final String? unit;

  const PredictionForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.resultKey,
    this.unit,
  });

  @override
  State<PredictionForm> createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _loading = false;
  dynamic _result;
  String? _error;

  // Convert string values to appropriate types for the backend
  Map<String, dynamic> _prepareData() {
    final prepared = <String, dynamic>{};
    for (final field in widget.fields) {
      final raw = _formData[field.name];
      if (field.type == 'number') {
        // Try parsing as int, then double
        final asDouble = double.tryParse(raw?.toString() ?? '');
        final asInt = int.tryParse(raw?.toString() ?? '');
        // Use int if it's a whole number, otherwise double
        if (asInt != null && asInt.toDouble() == asDouble) {
          prepared[field.name] = asInt;
        } else {
          prepared[field.name] = asDouble ?? 0.0;
        }
      } else if (field.type == 'select') {
        // Boolean selects
        if (raw == 'True') {
          prepared[field.name] = true;
        } else if (raw == 'False') {
          prepared[field.name] = false;
        } else {
          prepared[field.name] = raw ?? '';
        }
      } else {
        prepared[field.name] = raw ?? '';
      }
    }
    return prepared;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });
    try {
      final data = _prepareData();
      final res = await widget.onSubmit(data);

      if (res.data is Map && (res.data as Map).containsKey('error')) {
        setState(() => _error = res.data['error'].toString());
      } else {
        setState(() => _result = res.data);
      }
    } catch (e) {
      setState(() => _error = 'Failed to connect to server. Is the backend running?');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form fields
              ...widget.fields.asMap().entries.map((entry) {
                final i = entry.key;
                final field = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildField(field)
                      .animate(delay: Duration(milliseconds: 50 * i))
                      .fadeIn()
                      .slideX(begin: -0.05, end: 0),
                );
              }),

              const SizedBox(height: 8),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _loading ? null : _handleSubmit,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.analytics_outlined),
                label: Text(_loading ? 'Calculating...' : 'Predict'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
              ).animate().fadeIn(delay: 200.ms),

              // Error display
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
                        child: Text(
                          _error!,
                          style: GoogleFonts.inter(
                              color: Colors.red[700], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(),
              ],

              // Result display
              if (_result != null) ...[
                const SizedBox(height: 24),
                _ResultCard(
                    result: _result,
                    resultKey: widget.resultKey,
                    unit: widget.unit),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(PfFormField field) {
    if (field.type == 'select' && field.options != null) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: field.label,
          filled: true,
          fillColor: const Color(0xFFF5F7F5),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        hint: Text('Select ${field.label}',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
        items: field.options!
            .map((opt) =>
                DropdownMenuItem(value: opt, child: Text(opt)))
            .toList(),
        onChanged: (val) =>
            setState(() => _formData[field.name] = val),
        validator: (val) =>
            val == null ? 'Please select ${field.label}' : null,
      );
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.placeholder ?? '',
      ),
      keyboardType: field.type == 'number'
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      onChanged: (val) => _formData[field.name] = val,
      validator: (val) =>
          (val == null || val.trim().isEmpty) ? 'Required' : null,
    );
  }
}

// ── Result Card ─────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final dynamic result;
  final String resultKey;
  final String? unit;

  const _ResultCard(
      {required this.result, required this.resultKey, this.unit});

  @override
  Widget build(BuildContext context) {
    String displayValue;
    if (result is Map && (result as Map).containsKey(resultKey)) {
      final raw = (result as Map)[resultKey];
      if (raw is double) {
        displayValue = raw.toStringAsFixed(2);
      } else {
        displayValue = raw.toString();
      }
    } else {
      displayValue = result.toString();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA5D6A7)),
        boxShadow: [
          BoxShadow(
              color: Colors.green.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Text(
            'PREDICTION RESULT',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                displayValue,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: kAgriGreen,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 6),
                Text(unit!,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.96, 0.96));
  }
}
