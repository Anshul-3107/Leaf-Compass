import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shared chat message bubble — used by both ChatScreen and FloatingChatbot.
/// Unifies font sizes, border radii, and max widths.
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final int index;

  /// Whether to show the avatar. Set to false for compact floating chat.
  final bool showAvatar;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.index = 0,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width * 0.78;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bot avatar
          if (!isUser && showAvatar) _botAvatar(context),
          if (!isUser && showAvatar) const SizedBox(width: AppSpacing.sm),
          if (!isUser && !showAvatar) const SizedBox(width: 4),

          // Bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxW),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: isUser ? context.themeColors.primary : context.themeColors.surfaceContainer,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppSpacing.radiusXl),
                  topRight: const Radius.circular(AppSpacing.radiusXl),
                  bottomLeft: Radius.circular(isUser ? AppSpacing.radiusXl : 6),
                  bottomRight: Radius.circular(isUser ? 6 : AppSpacing.radiusXl),
                ),
                border: isUser
                    ? null
                    : Border.all(color: context.themeColors.surfaceDim),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: context.bodyMedium.copyWith(
                  color: isUser ? Colors.white : context.themeColors.onSurface,
                ),
              ),
            ),
          ),

          // User avatar
          if (isUser && showAvatar) const SizedBox(width: AppSpacing.sm),
          if (isUser && showAvatar) _userAvatar(context),
          if (isUser && !showAvatar) const SizedBox(width: 4),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 30 * (index % 10)))
        .fadeIn(duration: 200.ms)
        .slideY(begin: 0.04, end: 0, duration: 200.ms);
  }

  Widget _botAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.themeColors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.smart_toy, size: 18, color: context.themeColors.primary),
    );
  }

  Widget _userAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.themeColors.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: 18, color: context.themeColors.onSurfaceVariant),
    );
  }
}

/// Typing indicator bubble for bot "thinking" state.
class ChatTypingIndicator extends StatelessWidget {
  final bool showAvatar;
  const ChatTypingIndicator({super.key, this.showAvatar = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (showAvatar)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.themeColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.smart_toy, size: 18, color: context.themeColors.primary),
            ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: context.themeColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(color: context.themeColors.surfaceDim),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated dots
                ...List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: context.themeColors.primary.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(
                          onPlay: (c) => c.repeat(reverse: true),
                          delay: Duration(milliseconds: 200 * i),
                        )
                        .scaleXY(begin: 0.6, end: 1.0, duration: 500.ms)
                        .then()
                        .scaleXY(begin: 1.0, end: 0.6, duration: 500.ms),
                  );
                }),
                const SizedBox(width: AppSpacing.sm),
                Text('Thinking...',
                    style: context.bodySmall.copyWith(
                      color: context.themeColors.onSurfaceMuted,
                    )),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}
