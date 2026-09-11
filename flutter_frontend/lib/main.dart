import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_typography.dart';
import 'theme/app_theme.dart';
import 'widgets/chat_bubble.dart';

import 'screens/home_screen.dart';
import 'screens/disease_screen.dart';
import 'screens/yield_screen.dart';
import 'screens/crop_screen.dart';
import 'screens/fertilizer_screen.dart';
import 'screens/chat_screen.dart';
import 'services/api_service.dart';

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
      statusBarColor: AppColors.primary,
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
      theme: AppTheme.light,
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

  // 5 nav items (AI Chat removed — accessible via floating FAB)
  static const _navItems = [
    (label: 'Home',       icon: Icons.home_outlined,       active: Icons.home,        path: '/'),
    (label: 'Disease',    icon: Icons.biotech_outlined,    active: Icons.biotech,     path: '/disease'),
    (label: 'Yield',      icon: Icons.trending_up_outlined,active: Icons.trending_up, path: '/yield'),
    (label: 'Crop',       icon: Icons.grass_outlined,      active: Icons.grass,       path: '/crop'),
    (label: 'Fertilizer', icon: Icons.water_drop_outlined, active: Icons.water_drop,  path: '/fertilizer'),
  ];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _navItems.length; i++) {
      if (_navItems[i].path == loc) return i;
    }
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.surfaceDim, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex(context),
          onDestinationSelected: (i) {
            context.go(_navItems[i].path);
          },
          destinations: _navItems.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.active, color: AppColors.primary),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Floating AgroBot Widget ───────────────────────────────────────────────
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
          // ── Chat Panel ──
          if (widget.isOpen)
            Container(
              width: 320,
              height: 400,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(color: AppColors.surfaceDim),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  // ── Header bar ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppSpacing.radiusXl)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.smart_toy,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AgroBot',
                                  style: AppTypography.labelLarge
                                      .copyWith(color: Colors.white)),
                              Text('AI Farming Assistant',
                                  style: AppTypography.labelSmall.copyWith(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      letterSpacing: 0)),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: widget.onToggle,
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Messages ──
                  Expanded(
                    child: Container(
                      color: AppColors.surface,
                      child: ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: _msgs.length + (_loading ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (_loading && i == _msgs.length) {
                            return const ChatTypingIndicator(showAvatar: false);
                          }
                          final m = _msgs[i];
                          final isUser = m['s'] == 'user';
                          return ChatBubble(
                            text: m['t']!,
                            isUser: isUser,
                            index: i,
                            showAvatar: false,
                          );
                        },
                      ),
                    ),
                  ),

                  // ── Input row ──
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(AppSpacing.radiusXl)),
                      border: Border(
                        top: BorderSide(color: AppColors.surfaceDim),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            style: AppTypography.bodySmall,
                            decoration: InputDecoration(
                              hintText: 'Ask about crops...',
                              hintStyle: AppTypography.bodySmall.copyWith(
                                  color: AppColors.onSurfaceMuted),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.surfaceContainerHigh,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.radiusFull),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.radiusFull),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.radiusFull),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 1.5)),
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Material(
                          color: AppColors.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _send,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.send,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 200.ms)
                .slideY(begin: 0.06, end: 0, duration: 200.ms),

          // ── FAB ──
          Material(
            color: AppColors.secondary,
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: AppColors.secondary.withValues(alpha: 0.4),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.onToggle,
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isOpen ? Icons.close : Icons.chat_bubble_rounded,
                    key: ValueKey(widget.isOpen),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
