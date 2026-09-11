import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dio/dio.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'error_banner.dart';
import 'result_card.dart';
import 'screen_header.dart';

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
/// Accepts a list of [PfFormField] definitions, an [onSubmit] API call,
/// the [resultKey] to read from the response, and an optional [unit].
class PredictionForm extends StatefulWidget {
  final String title;
  final List<PfFormField> fields;
  final Future<Response> Function(Map<String, dynamic>) onSubmit;
  final String resultKey;
  final String? unit;

  /// Optional: screen header customization
  final IconData headerIcon;
  final String headerTitle;
  final String headerDescription;
  final Color? accentColor;

  const PredictionForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.resultKey,
    this.unit,
    this.headerIcon = Icons.analytics_outlined,
    this.headerTitle = '',
    this.headerDescription = '',
    this.accentColor,
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
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Screen Header ──
              if (widget.headerTitle.isNotEmpty)
                ScreenHeader(
                  icon: widget.headerIcon,
                  title: widget.headerTitle,
                  description: widget.headerDescription,
                  accentColor: widget.accentColor ?? context.themeColors.primary,
                ),

              // ── Form fields ──
              ...widget.fields.asMap().entries.map((entry) {
                final i = entry.key;
                final field = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.formFieldGap),
                  child: _buildField(field)
                      .animate(delay: Duration(milliseconds: 40 * i))
                      .fadeIn()
                      .slideX(begin: -0.04, end: 0),
                );
              }),

              const SizedBox(height: AppSpacing.sm),

              // ── Submit Button ──
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
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: widget.accentColor ?? context.themeColors.primary,
                ),
              ).animate().fadeIn(delay: 200.ms),

              // ── Error display ──
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.lg),
                ErrorBanner(
                  message: _error!,
                  onDismiss: () => setState(() => _error = null),
                ),
              ],

              // ── Result display ──
              if (_result != null) ...[
                const SizedBox(height: AppSpacing.xxl),
                _buildResult(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    String displayValue;
    if (_result is Map && (_result as Map).containsKey(widget.resultKey)) {
      final raw = (_result as Map)[widget.resultKey];
      if (raw is double) {
        displayValue = raw.toStringAsFixed(2);
      } else {
        displayValue = raw.toString();
      }
    } else {
      displayValue = _result.toString();
    }

    return ResultCard(
      displayValue: displayValue,
      unit: widget.unit,
      accentColor: widget.accentColor ?? context.themeColors.primary,
    );
  }

  Widget _buildField(PfFormField field) {
    if (field.type == 'select' && field.options != null) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: field.label),
        hint: Text('Select ${field.label}',
            style: context.bodySmall
                .copyWith(color: context.themeColors.onSurfaceMuted)),
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
