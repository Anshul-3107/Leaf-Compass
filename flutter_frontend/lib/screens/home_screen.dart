import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';


import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';

// ── Home Screen ────────────────────────────────────────────────────────────
/// Mirrors home.jsx: hero section, dashboard widgets, features grid
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const _dailyTips = [
    '💡 Tip: Water your crops early in the morning (6–9 AM) to minimize evaporation and prevent fungal diseases.',
    '💡 Tip: Rotate crops each season to prevent soil nutrient depletion and break pest cycles.',
    '💡 Tip: Test your soil pH every 2-3 years to ensure optimal nutrient absorption for your plants.',
    '💡 Tip: Use organic mulch to retain soil moisture, suppress weeds, and slowly add nutrients back.',
    '💡 Tip: Introduce beneficial insects like ladybugs to naturally control pest populations.',
    '💡 Tip: Practice deep, infrequent watering to encourage deeper root growth and drought resistance.',
    '💡 Tip: Clean your farming tools regularly to prevent spreading soil-borne diseases.',
    '💡 Tip: Monitor for pests regularly; early detection makes natural interventions much more effective.',
    '💡 Tip: Plant cover crops during the off-season to prevent erosion and improve soil structure.',
    '💡 Tip: Prune dead or diseased foliage promptly to improve air circulation and direct energy to healthy growth.',
  ];

  static List<Map<String, dynamic>> _getFeatures(BuildContext context) {
    return [
    {
      'title': 'Disease Detection',
      'desc': 'Upload a leaf photo to instantly identify plant diseases with AI.',
      'path': '/disease',
      'icon': Icons.biotech,
      'color': context.themeColors.accentDiseaseLight,
      'iconColor': context.themeColors.accentDisease,
    },
    {
      'title': 'Yield Prediction',
      'desc': 'Estimate crop production from weather and soil parameters.',
      'path': '/yield',
      'icon': Icons.trending_up,
      'color': context.themeColors.accentYieldLight,
      'iconColor': context.themeColors.accentYield,
    },
    {
      'title': 'Crop Recommendation',
      'desc': 'Find the most suitable crop for your soil conditions.',
      'path': '/crop',
      'icon': Icons.grass,
      'color': context.themeColors.accentCropLight,
      'iconColor': context.themeColors.accentCrop,
    },
    {
      'title': 'Fertilizer Adviser',
      'desc': 'Get precise nutrient recommendations for healthy growth.',
      'path': '/fertilizer',
      'icon': Icons.water_drop,
      'color': context.themeColors.accentFertilizerLight,
      'iconColor': context.themeColors.accentFertilizer,
    },
    {
      'title': 'AgroBot AI',
      'desc': 'Chat with our AI expert for instant farming advice.',
      'path': '/chat',
      'icon': Icons.smart_toy,
      'color': context.themeColors.accentChatLight,
      'iconColor': context.themeColors.accentChat,
    },
    ];
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherData? _weather;
  bool _weatherLoading = true;
  String? _weatherError;
  bool _permDeniedForever = false;
  bool _locationDisabled = false;

  late String _currentTip;

  @override
  void initState() {
    super.initState();
    _currentTip = HomeScreen._dailyTips[DateTime.now().millisecond % HomeScreen._dailyTips.length];
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _weatherLoading = true;
      _weatherError = null;
      _permDeniedForever = false;
      _locationDisabled = false;
    });
    try {
      final data = await WeatherService.fetchCurrentWeather();
      if (mounted) setState(() { _weather = data; _weatherLoading = false; });
    } on LocationServiceDisabledException {
      if (mounted) {
        setState(() {
          _weatherLoading = false;
          _locationDisabled = true;
          _weatherError = 'Location services are disabled.';
        });
      }
    } on LocationPermissionException catch (e) {
      if (mounted) {
        setState(() {
          _weatherLoading = false;
          _permDeniedForever = e.isPermanent;
          _weatherError = e.isPermanent
              ? 'Location permission permanently denied.'
              : 'Location permission denied.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _weatherLoading = false;
          _weatherError = 'Could not load weather data.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero SliverAppBar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: context.themeColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroSection(),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.eco, color: Colors.white, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('LeafCompass',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
            actions: [
              PopupMenuButton<ThemeMode>(
                icon: const Icon(Icons.brightness_6, color: Colors.white),
                onSelected: (mode) {
                  Provider.of<ThemeProvider>(context, listen: false).setThemeMode(mode);
                },
                itemBuilder: (context) {
                  final current = Provider.of<ThemeProvider>(context, listen: false).themeMode;
                  return [
                    PopupMenuItem(
                      value: ThemeMode.light,
                      child: Row(
                        children: [
                          Icon(Icons.light_mode, size: 18, color: current == ThemeMode.light ? context.themeColors.primary : context.themeColors.onSurface),
                          const SizedBox(width: 8),
                          Text('Light', style: context.bodyMedium),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: ThemeMode.dark,
                      child: Row(
                        children: [
                          Icon(Icons.dark_mode, size: 18, color: current == ThemeMode.dark ? context.themeColors.primary : context.themeColors.onSurface),
                          const SizedBox(width: 8),
                          Text('Dark', style: context.bodyMedium),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: ThemeMode.system,
                      child: Row(
                        children: [
                          Icon(Icons.settings_system_daydream, size: 18, color: current == ThemeMode.system ? context.themeColors.primary : context.themeColors.onSurface),
                          const SizedBox(width: 8),
                          Text('System', style: context.bodyMedium),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH, 0, AppSpacing.screenH, bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Dashboard Widgets ──────────────────────────────────
                  const SizedBox(height: AppSpacing.xl),
                  Text('Dashboard', style: context.titleLarge),
                  const SizedBox(height: AppSpacing.md),

                  // Weather Card (live data)
                  _WeatherCard(
                    weather: _weather,
                    isLoading: _weatherLoading,
                    error: _weatherError,
                    permDeniedForever: _permDeniedForever,
                    locationDisabled: _locationDisabled,
                    onRetry: _fetchWeather,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _TipCard(tip: _currentTip),

                  // ── Features Grid ──────────────────────────────────────
                  const SizedBox(height: AppSpacing.xxxl),
                  Text('Tools & Services', style: context.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final width = constraints.maxWidth;
                      final cols = width > 500 ? 3 : 2;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: HomeScreen._getFeatures(context).length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                        ),
                        itemBuilder: (ctx, i) => _FeatureCard(
                          feature: HomeScreen._getFeatures(context)[i],
                          index: i,
                        ),
                      );
                    },
                  ),

                  // ── Footer ─────────────────────────────────────────────
                  const SizedBox(height: AppSpacing.xxxl),
                  const _FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Section ──────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.themeColors.heroGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to LeafCompass',
                textAlign: TextAlign.center,
                style: context.headline.copyWith(
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your all-in-one smart farming companion.\nDiagnose crops, predict yields & get expert advice.',
                textAlign: TextAlign.center,
                style: context.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  _HeroButton(
                    label: 'Diagnose Now',
                    icon: Icons.biotech,
                    path: '/disease',
                    isPrimary: true,
                  ),
                  _HeroButton(
                    label: 'Ask AI',
                    icon: Icons.smart_toy,
                    path: '/chat',
                    isPrimary: false,
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  final String label, path;
  final IconData icon;
  final bool isPrimary;

  const _HeroButton(
      {required this.label,
      required this.icon,
      required this.path,
      required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      elevation: isPrimary ? 4 : 0,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        onTap: () => context.go(path),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          decoration: isPrimary
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4)),
                ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 18,
                  color: isPrimary ? context.themeColors.primary : Colors.white),
              const SizedBox(width: AppSpacing.sm),
              Text(label,
                  style: context.labelLarge.copyWith(
                      color: isPrimary ? context.themeColors.primary : Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Weather Card ──────────────────────────────────────────────────────────
class _WeatherCard extends StatelessWidget {
  final WeatherData? weather;
  final bool isLoading;
  final String? error;
  final bool permDeniedForever;
  final bool locationDisabled;
  final VoidCallback onRetry;

  const _WeatherCard({
    required this.weather,
    required this.isLoading,
    required this.error,
    required this.permDeniedForever,
    required this.locationDisabled,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // ── Loading state ──
    if (isLoading) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny,
                      color: context.themeColors.secondary, size: 16),
                  const SizedBox(width: AppSpacing.sm),
                  Text('WEATHER', style: context.labelSmall),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // Skeleton placeholders
              _SkeletonLine(width: 100, height: 28),
              const SizedBox(height: AppSpacing.sm),
              _SkeletonLine(width: 180, height: 14),
              const SizedBox(height: AppSpacing.lg),
              _SkeletonLine(width: 200, height: 30),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 100.ms);
    }

    // ── Error / permission denied state ──
    if (error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny,
                      color: context.themeColors.secondary, size: 16),
                  const SizedBox(width: AppSpacing.sm),
                  Text('WEATHER', style: context.labelSmall),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Icon(
                    locationDisabled
                        ? Icons.location_off
                        : permDeniedForever
                            ? Icons.block
                            : Icons.cloud_off,
                    color: context.themeColors.onSurfaceMuted,
                    size: 28,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(error!, style: context.bodyMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          locationDisabled
                              ? 'Enable location services to see live weather.'
                              : permDeniedForever
                                  ? 'Open settings to grant location access.'
                                  : 'Check your connection and try again.',
                          style: context.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (locationDisabled) {
                      await Geolocator.openLocationSettings();
                    } else if (permDeniedForever) {
                      await Geolocator.openAppSettings();
                    } else {
                      onRetry();
                    }
                  },
                  icon: Icon(
                    locationDisabled || permDeniedForever
                        ? Icons.settings
                        : Icons.refresh,
                    size: 18,
                  ),
                  label: Text(
                    locationDisabled
                        ? 'Open Location Settings'
                        : permDeniedForever
                            ? 'Open App Settings'
                            : 'Retry',
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 150.ms);
    }

    // ── Loaded state ──
    final w = weather!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(w.weatherIcon,
                    color: context.themeColors.secondary, size: 16),
                const SizedBox(width: AppSpacing.sm),
                Text('WEATHER', style: context.labelSmall),
                const Spacer(),
                // Live indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.themeColors.successContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: context.themeColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('Live', style: context.labelSmall.copyWith(
                        color: context.themeColors.success,
                        fontSize: 10,
                      )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${w.temperature}°C',
                        style: context.display),
                    const SizedBox(height: AppSpacing.xs),
                    Text('${w.condition} • ${w.location}',
                        style: context.labelMedium),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.themeColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(w.weatherIcon,
                      size: 32, color: context.themeColors.secondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.themeColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop,
                      size: 14, color: context.themeColors.tertiary),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${w.humidity}% Humidity',
                      style: context.labelMedium
                          .copyWith(color: context.themeColors.onSurfaceVariant)),
                  const SizedBox(width: AppSpacing.md),
                  Icon(Icons.air,
                      size: 14, color: context.themeColors.tertiary),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${w.windSpeed} km/h',
                      style: context.labelMedium
                          .copyWith(color: context.themeColors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.06, end: 0);
  }
}

// ── Skeleton Line (loading placeholder) ───────────────────────────────────
class _SkeletonLine extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonLine({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.themeColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 1200.ms, color: context.themeColors.surfaceDim.withValues(alpha: 0.5));
  }
}

// ── Daily Tip Card ─────────────────────────────────────────────────────────
class _TipCard extends StatelessWidget {
  final String tip;

  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border(
              left: BorderSide(color: context.themeColors.secondary, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    size: 14, color: context.themeColors.secondary),
                const SizedBox(width: AppSpacing.sm),
                Text('DAILY TIP', style: context.labelSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              tip,
              style: context.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              onTap: () => context.go('/chat'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Get more tips',
                        style: context.labelLarge
                            .copyWith(color: context.themeColors.primary)),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(Icons.arrow_forward,
                        size: 14, color: context.themeColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.06, end: 0);
  }
}

// ── Feature Card ───────────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final Map<String, dynamic> feature;
  final int index;
  const _FeatureCard({required this.feature, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: () => context.go(feature['path'] as String),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: feature['color'] as Color,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: feature['iconColor'] as Color,
                  size: 22,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                feature['title'] as String,
                style: context.labelLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: Text(
                  feature['desc'] as String,
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w400,
                    color: context.themeColors.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Text('Explore',
                      style: context.labelMedium
                          .copyWith(color: feature['iconColor'] as Color)),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(Icons.arrow_forward,
                      size: 12, color: feature['iconColor'] as Color),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn()
        .slideY(begin: 0.08, end: 0);
  }
}

// ── Footer Section ─────────────────────────────────────────────────────────
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.themeColors.footerBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LeafCompass 🌿',
                      style: context.titleMedium
                          .copyWith(color: Colors.white)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Empowering farmers with AI-driven insights.',
                      style: context.labelMedium
                          .copyWith(color: context.themeColors.footerText)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.code, color: context.themeColors.footerText),
                    onPressed: () => _launch(
                        'https://github.com/Anshul-3107/Leaf-Compass'),
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.mail_outline, color: context.themeColors.footerText),
                    onPressed: () =>
                        _launch('mailto:anshularohi31072004@gmail.com'),
                  ),
                  IconButton(
                    icon: Icon(Icons.phone_outlined,
                        color: context.themeColors.footerText),
                    onPressed: () => _launch('tel:+917007535723'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: context.themeColors.footerText.withValues(alpha: 0.3)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Made with ',
                  style: context.labelMedium
                      .copyWith(color: context.themeColors.footerText)),
              Icon(Icons.favorite, color: context.themeColors.error, size: 14),
              Text(' for farmers. © ${DateTime.now().year} | Anshul Arohi',
                  style: context.labelMedium
                      .copyWith(color: context.themeColors.footerText)),
            ],
          ),
        ],
      ),
    );
  }
}
