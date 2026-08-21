import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart'; // kAgriGreen, kAgriGreenLight, etc.

// ── Home Screen ────────────────────────────────────────────────────────────
/// Mirrors home.jsx: hero section, dashboard widgets, features grid
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mock data (same as home.jsx)
  static const _weatherData = {
    'temp': '28',
    'condition': 'Sunny',
    'humidity': '65',
    'wind': '12',
    'location': 'Prayagraj, India',
  };

  static const _marketRates = [
    {'crop': 'Wheat', 'price': '₹2,125/qt', 'trend': 'up'},
    {'crop': 'Rice', 'price': '₹2,900/qt', 'trend': 'stable'},
    {'crop': 'Cotton', 'price': '₹6,200/qt', 'trend': 'down'},
  ];

  static const _dailyTip =
      '💡 Tip: Water your crops early in the morning (6–9 AM) to minimize evaporation and prevent fungal diseases.';

  static const _features = [
    {
      'title': 'Disease Detection',
      'desc': 'Upload a photo of a leaf to detect diseases instantly.',
      'path': '/disease',
      'icon': Icons.biotech,
      'color': Color(0xFFFFEBEE),
      'iconColor': Color(0xFFE53935),
    },
    {
      'title': 'Yield Prediction',
      'desc': 'Estimate crop production based on weather parameters.',
      'path': '/yield',
      'icon': Icons.trending_up,
      'color': Color(0xFFE3F2FD),
      'iconColor': Color(0xFF1E88E5),
    },
    {
      'title': 'Crop Recommendation',
      'desc': 'Find the most suitable crop for your soil type.',
      'path': '/crop',
      'icon': Icons.grass,
      'color': Color(0xFFE8F5E9),
      'iconColor': Color(0xFF43A047),
    },
    {
      'title': 'Fertilizer Adviser',
      'desc': 'Get nutrient recommendations for healthy growth.',
      'path': '/fertilizer',
      'icon': Icons.water_drop,
      'color': Color(0xFFFFFDE7),
      'iconColor': Color(0xFFFB8C00),
    },
    {
      'title': 'AgroBot AI',
      'desc': 'Chat with our expert AI for instant farming advice.',
      'path': '/chat',
      'icon': Icons.smart_toy,
      'color': Color(0xFFF3E5F5),
      'iconColor': Color(0xFF8E24AA),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero SliverAppBar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 290,
            floating: false,
            pinned: true,
            backgroundColor: kAgriGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroSection(),
            ),
            title: Row(
              children: [
                const Icon(Icons.eco, color: Colors.white),
                const SizedBox(width: 8),
                Text('LeafCompass',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Dashboard Widgets ──────────────────────────────────
                  const SizedBox(height: 20),
                  Text('Dashboard',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  // Weather Card
                  _WeatherCard(data: _weatherData),
                  const SizedBox(height: 12),
                  // Tip + Market in a row on wider screens
                  LayoutBuilder(builder: (ctx, constraints) {
                    if (constraints.maxWidth > 500) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _TipCard()),
                          const SizedBox(width: 12),
                          Expanded(child: _MarketCard(rates: _marketRates)),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _TipCard(),
                        const SizedBox(height: 12),
                        _MarketCard(rates: _marketRates),
                      ],
                    );
                  }),

                  // ── Features Grid ──────────────────────────────────────
                  const SizedBox(height: 28),
                  Text('Tools & Services',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final width = constraints.maxWidth;
                      // Use 2 columns on phones, 3 on wider screens
                      final cols = width > 500 ? 3 : 2;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _features.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (ctx, i) => _FeatureCard(
                          feature: _features[i],
                          index: i,
                        ),
                      );
                    },
                  ),

                  // ── Footer ─────────────────────────────────────────────
                  const SizedBox(height: 32),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to LeafCompass',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 6),
              Text(
                'Your all-in-one smart farming companion.\nDiagnose crops, predict yields & get expert advice.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: Colors.green[100], fontSize: 12, height: 1.4),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
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
    return GestureDetector(
      onTap: () => context.go(path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : const Color(0xFF2E7D32),
          borderRadius: BorderRadius.circular(30),
          border: isPrimary ? null : Border.all(color: Colors.green[400]!),
          boxShadow: [
            if (isPrimary)
              const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: isPrimary ? kAgriGreen : Colors.white),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: isPrimary ? kAgriGreen : Colors.white,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ── Weather Card ──────────────────────────────────────────────────────────
class _WeatherCard extends StatelessWidget {
  final Map<String, String> data;
  const _WeatherCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.wb_sunny, color: Color(0xFFFB8C00), size: 16),
                const SizedBox(width: 6),
                Text('WEATHER',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                        letterSpacing: 0.8)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data['temp']}°C',
                        style: GoogleFonts.inter(
                            fontSize: 28, fontWeight: FontWeight.w800)),
                    Text('${data['condition']} • ${data['location']}',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                const Icon(Icons.wb_sunny,
                    size: 44, color: Color(0xFFFDD835)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.water_drop, size: 14, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Text('${data['humidity']}% Humidity',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  const SizedBox(width: 12),
                  const Icon(Icons.air, size: 14, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Text('${data['wind']} km/h',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }
}

// ── Daily Tip Card ─────────────────────────────────────────────────────────
class _TipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: const Border(left: BorderSide(color: Color(0xFFFDD835), width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: Color(0xFF43A047)),
                const SizedBox(width: 6),
                Text('DAILY TIP',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                        letterSpacing: 0.8)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              HomeScreen._dailyTip,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[800],
                  height: 1.5),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => context.go('/chat'),
              child: Row(
                children: [
                  Text('Get more tips',
                      style: GoogleFonts.inter(
                          color: kAgriGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward,
                      size: 14, color: kAgriGreen),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }
}

// ── Market Rates Card ──────────────────────────────────────────────────────
class _MarketCard extends StatelessWidget {
  final List<Map<String, String>> rates;
  const _MarketCard({required this.rates});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: const Border(left: BorderSide(color: Color(0xFF43A047), width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up,
                    size: 14, color: Color(0xFF43A047)),
                const SizedBox(width: 6),
                Text('MARKET RATES',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                        letterSpacing: 0.8)),
              ],
            ),
            const SizedBox(height: 10),
            ...rates.map((item) {
              IconData trendIcon = Icons.remove;
              Color trendColor = Colors.grey;
              if (item['trend'] == 'up') {
                trendIcon = Icons.trending_up;
                trendColor = Colors.green;
              } else if (item['trend'] == 'down') {
                trendIcon = Icons.trending_down;
                trendColor = Colors.red;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['crop']!,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 13)),
                    Row(
                      children: [
                        Text(item['price']!,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(width: 4),
                        Icon(trendIcon, size: 14, color: trendColor),
                      ],
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0);
  }
}

// ── Feature Card ───────────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final Map<String, dynamic> feature;
  final int index;
  const _FeatureCard({required this.feature, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(feature['path'] as String),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // MainAxisSize.max fills the GridView tile height
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: feature['color'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: feature['iconColor'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                feature['title'] as String,
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  feature['desc'] as String,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: Colors.grey[600], height: 1.4),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Text('Try Tool',
                      style: GoogleFonts.inter(
                          color: kAgriGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 11)),
                  const SizedBox(width: 3),
                  const Icon(Icons.arrow_forward, size: 11, color: kAgriGreen),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn()
        .slideY(begin: 0.12, end: 0);
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LeafCompass 🌿',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Empowering farmers with AI-driven insights.',
                      style: GoogleFonts.inter(
                          color: Colors.grey[400], fontSize: 12)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.code, color: Colors.grey),
                    onPressed: () => _launch(
                        'https://github.com/Mayukh-Jain/Leaf-Compass'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mail_outline, color: Colors.grey),
                    onPressed: () =>
                        _launch('mailto:jainmayukh@gmail.com'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, color: Colors.grey),
                    onPressed: () =>
                        _launch('tel:+917007535723'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF374151)),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Made with ',
                  style:
                      GoogleFonts.inter(color: Colors.grey[400], fontSize: 12)),
              const Icon(Icons.favorite, color: Colors.red, size: 14),
              Text(' for farmers. © ${DateTime.now().year} | Mayukh Jain',
                  style:
                      GoogleFonts.inter(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
