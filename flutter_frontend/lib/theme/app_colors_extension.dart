import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryContainer;
  final Color onPrimary;

  final Color secondary;
  final Color secondaryDark;
  final Color secondaryContainer;
  final Color onSecondary;

  final Color tertiary;
  final Color tertiaryContainer;

  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceDim;

  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onSurfaceMuted;

  final Color error;
  final Color errorContainer;
  final Color onError;
  
  final Color success;
  final Color successContainer;

  final Color accentDisease;
  final Color accentDiseaseLight;
  final Color accentYield;
  final Color accentYieldLight;
  final Color accentCrop;
  final Color accentCropLight;
  final Color accentFertilizer;
  final Color accentFertilizerLight;
  final Color accentChat;
  final Color accentChatLight;

  final List<Color> heroGradient;
  final Color footerBg;
  final Color footerText;

  const AppColorsExtension({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryContainer,
    required this.onPrimary,
    required this.secondary,
    required this.secondaryDark,
    required this.secondaryContainer,
    required this.onSecondary,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceDim,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onSurfaceMuted,
    required this.error,
    required this.errorContainer,
    required this.onError,
    required this.success,
    required this.successContainer,
    required this.accentDisease,
    required this.accentDiseaseLight,
    required this.accentYield,
    required this.accentYieldLight,
    required this.accentCrop,
    required this.accentCropLight,
    required this.accentFertilizer,
    required this.accentFertilizerLight,
    required this.accentChat,
    required this.accentChatLight,
    required this.heroGradient,
    required this.footerBg,
    required this.footerText,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? primaryContainer,
    Color? onPrimary,
    Color? secondary,
    Color? secondaryDark,
    Color? secondaryContainer,
    Color? onSecondary,
    Color? tertiary,
    Color? tertiaryContainer,
    Color? surface,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceDim,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? onSurfaceMuted,
    Color? error,
    Color? errorContainer,
    Color? onError,
    Color? success,
    Color? successContainer,
    Color? accentDisease,
    Color? accentDiseaseLight,
    Color? accentYield,
    Color? accentYieldLight,
    Color? accentCrop,
    Color? accentCropLight,
    Color? accentFertilizer,
    Color? accentFertilizerLight,
    Color? accentChat,
    Color? accentChatLight,
    List<Color>? heroGradient,
    Color? footerBg,
    Color? footerText,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      accentDisease: accentDisease ?? this.accentDisease,
      accentDiseaseLight: accentDiseaseLight ?? this.accentDiseaseLight,
      accentYield: accentYield ?? this.accentYield,
      accentYieldLight: accentYieldLight ?? this.accentYieldLight,
      accentCrop: accentCrop ?? this.accentCrop,
      accentCropLight: accentCropLight ?? this.accentCropLight,
      accentFertilizer: accentFertilizer ?? this.accentFertilizer,
      accentFertilizerLight: accentFertilizerLight ?? this.accentFertilizerLight,
      accentChat: accentChat ?? this.accentChat,
      accentChatLight: accentChatLight ?? this.accentChatLight,
      heroGradient: heroGradient ?? this.heroGradient,
      footerBg: footerBg ?? this.footerBg,
      footerText: footerText ?? this.footerText,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryDark: Color.lerp(secondaryDark, other.secondaryDark, t)!,
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryContainer: Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      accentDisease: Color.lerp(accentDisease, other.accentDisease, t)!,
      accentDiseaseLight: Color.lerp(accentDiseaseLight, other.accentDiseaseLight, t)!,
      accentYield: Color.lerp(accentYield, other.accentYield, t)!,
      accentYieldLight: Color.lerp(accentYieldLight, other.accentYieldLight, t)!,
      accentCrop: Color.lerp(accentCrop, other.accentCrop, t)!,
      accentCropLight: Color.lerp(accentCropLight, other.accentCropLight, t)!,
      accentFertilizer: Color.lerp(accentFertilizer, other.accentFertilizer, t)!,
      accentFertilizerLight: Color.lerp(accentFertilizerLight, other.accentFertilizerLight, t)!,
      accentChat: Color.lerp(accentChat, other.accentChat, t)!,
      accentChatLight: Color.lerp(accentChatLight, other.accentChatLight, t)!,
      heroGradient: [
        Color.lerp(heroGradient[0], other.heroGradient[0], t)!,
        Color.lerp(heroGradient[1], other.heroGradient[1], t)!,
        Color.lerp(heroGradient[2], other.heroGradient[2], t)!,
      ],
      footerBg: Color.lerp(footerBg, other.footerBg, t)!,
      footerText: Color.lerp(footerText, other.footerText, t)!,
    );
  }
}

extension AppColorsExtensionHelper on BuildContext {
  AppColorsExtension get themeColors => Theme.of(this).extension<AppColorsExtension>()!;
}
