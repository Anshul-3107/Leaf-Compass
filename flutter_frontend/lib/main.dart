import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'screens/home_screen.dart';
import 'screens/disease_screen.dart';
import 'screens/yield_screen.dart';
import 'screens/crop_screen.dart';
import 'screens/fertilizer_screen.dart';
import 'screens/chat_screen.dart';
import 'services/api_service.dart';

// ── Color palette (mirrors Tailwind custom colors in tailwind.config.js) ──
const Color kAgriGreen = Color(0xFF2E7D32);
const Color kAgriGreenLight = Color(0xFFE8F5E9);
const Color kAgriGreenDark = Color(0xFF1B5E20);
const Color kSurface = Color(0xFFF8FAF8);

// ── Router definition ──────────────────────────────────────────────────────
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(path: '/',           builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/disease',    builder: (context, state) => const DiseaseScreen()),
        GoRoute(path: '/yield',      builder: (context, state) => const YieldScreen()),
        GoRoute(path: '/crop',       builder: (context, state) => const CropScreen()),
        GoRoute(path: '/fertilizer', builder: (context, state) => const FertilizerScreen()),
        GoRoute(path: '/chat',       builder: (context, state) => const ChatScreen()),
      ],
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kAgriGreen,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const LeafCompassApp());
}

// ── Root App ───────────────────────────────────────────────────────────────
class LeafCompassApp extends StatelessWidget {
  const LeafCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LeafCompass',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAgriGreen,
          primary: kAgriGreen,
          secondary: kAgriGreenDark,
          surface: kSurface,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kSurface,
        appBarTheme: AppBarTheme(
          backgroundColor: kAgriGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAgriGreen,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F7F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDE0DD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDE0DD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kAgriGreen, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          labelStyle: const TextStyle(color: Color(0xFF555555)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: kAgriGreenLight,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(
                  fontWeight: FontWeight.w600, color: kAgriGreen, fontSize: 12);
            }
            return GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]);
          }),
        ),
      ),
    );
  }
}

// ── App Shell: persistent BottomNav + Floating Chatbot ────────────────────
class _AppShell extends StatefulWidget {
  final Widget child;
  const _AppShell({required this.child});

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  bool _chatbotOpen = false;

  // Nav items mirroring Header.jsx navItems
  static const _navItems = [
    (label: 'Home',       icon: Icons.home_outlined,      active: Icons.home,             path: '/'),
    (label: 'Disease',    icon: Icons.biotech_outlined,   active: Icons.biotech,          path: '/disease'),
    (label: 'Yield',      icon: Icons.trending_up_outlined,active: Icons.trending_up,     path: '/yield'),
    (label: 'Crop',       icon: Icons.grass_outlined,     active: Icons.grass,            path: '/crop'),
    (label: 'Fertilizer', icon: Icons.water_drop_outlined,active: Icons.water_drop,       path: '/fertilizer'),
    (label: 'AI Chat',    icon: Icons.smart_toy_outlined, active: Icons.smart_toy,        path: '/chat'),
  ];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    // Exact match first
    for (int i = 0; i < _navItems.length; i++) {
      if (_navItems[i].path == loc) return i;
    }
    // Prefix match fallback
    for (int i = _navItems.length - 1; i >= 0; i--) {
      if (loc.startsWith(_navItems[i].path) && _navItems[i].path != '/') {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          _FloatingChatbot(
            isOpen: _chatbotOpen,
            onToggle: () => setState(() => _chatbotOpen = !_chatbotOpen),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (i) {
          if (_navItems[i].path == '/chat') {
            setState(() => _chatbotOpen = false);
          }
          context.go(_navItems[i].path);
        },
        destinations: _navItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.active, color: kAgriGreen),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

// ── Floating AgroBot Widget (mirrors Chatbot.jsx) ─────────────────────────
class _FloatingChatbot extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  const _FloatingChatbot({required this.isOpen, required this.onToggle});

  @override
  State<_FloatingChatbot> createState() => _FloatingChatbotState();
}

class _FloatingChatbotState extends State<_FloatingChatbot> {
  final List<Map<String, String>> _msgs = [
    {'s': 'bot', 't': 'Hi! I am AgroBot. Ask me anything about farming! 🌾'},
  ];
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _loading = false;

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add({'s': 'user', 't': text});
      _loading = true;
    });
    _ctrl.clear();
    _scrollDown();
    try {
      final res = await ApiService.chatWithBot(text);
      setState(() => _msgs.add({
            's': 'bot',
            't': res.data['response'] as String? ?? '...'
          }));
    } catch (_) {
      setState(
          () => _msgs.add({'s': 'bot', 't': 'Connection error. ⚠️'}));
    } finally {
      setState(() => _loading = false);
      _scrollDown();
    }
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 72,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chat Panel
          if (widget.isOpen)
            Container(
              width: 300,
              height: 360,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kAgriGreenLight),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 8))
                ],
              ),
              child: Column(
                children: [
                  // Header bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: const BoxDecoration(
                      color: kAgriGreen,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.smart_toy,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('AgroBot 🤖',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ),
                        GestureDetector(
                          onTap: widget.onToggle,
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  // Messages
                  Expanded(
                    child: Container(
                      color: const Color(0xFFF5F5F5),
                      child: ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.all(10),
                        itemCount: _msgs.length + (_loading ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (_loading && i == _msgs.length) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text('AgroBot is typing...',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey)),
                            );
                          }
                          final m = _msgs[i];
                          final isUser = m['s'] == 'user';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              constraints: const BoxConstraints(maxWidth: 210),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? kAgriGreen
                                    : const Color(0xFFDFDFDF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(m['t']!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: isUser
                                          ? Colors.white
                                          : Colors.black87)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Input row
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Ask about crops...',
                              hintStyle: const TextStyle(fontSize: 12),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: _send,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: kAgriGreen, shape: BoxShape.circle),
                            child: const Icon(Icons.send,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 180.ms)
                .slideY(begin: 0.08, end: 0, duration: 180.ms),

          // FAB
          GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: kAgriGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: kAgriGreen.withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Icon(
                widget.isOpen ? Icons.close : Icons.chat_bubble,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
