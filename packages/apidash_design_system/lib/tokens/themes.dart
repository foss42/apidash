import 'package:flutter/material.dart';
import 'typography.dart';

enum AppThemeType { defaultTheme, cafe }

extension AppThemeTypeLabel on AppThemeType {
  String get label => switch (this) {
        AppThemeType.defaultTheme => 'Default',
        AppThemeType.cafe => 'Café',
      };
}

class _AppThemePalette {
  const _AppThemePalette({
    required this.background,
    required this.card,
    required this.foreground,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.accent,
    required this.muted,
    required this.border,
  });

  final Color background;
  final Color card;
  final Color foreground;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color accent;
  final Color muted;
  final Color border;
}

class AppThemeBuilder {
  AppThemeBuilder._();

  static const _defaultLight = _AppThemePalette(
    background: Color(0xFFF7F9FF),
    card: Color(0xFFFFFFFF),
    foreground: Color(0xFF1F2937),
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFDBEAFE),
    accent: Color(0xFF60A5FA),
    muted: Color(0xFFEFF6FF),
    border: Color(0xFFBFDBFE),
  );
  static const _defaultDark = _AppThemePalette(
    background: Color(0xFF0F172A),
    card: Color(0xFF111827),
    foreground: Color(0xFFE5E7EB),
    primary: Color(0xFF60A5FA),
    onPrimary: Color(0xFF0F172A),
    secondary: Color(0xFF1E3A8A),
    accent: Color(0xFF93C5FD),
    muted: Color(0xFF172554),
    border: Color(0xFF334155),
  );

  static const _cafeLight = _AppThemePalette(
    background: Color(0xFFF5EFE6),
    card: Color(0xFFFFFBF5),
    foreground: Color(0xFF3B2A20),
    primary: Color(0xFF6F4E37),
    onPrimary: Color(0xFFFFF8F0),
    secondary: Color(0xFFD9C3A5),
    accent: Color(0xFFC8883A),
    muted: Color(0xFFE8DCCB),
    border: Color(0xFFDCCBB5),
  );
  static const _cafeDark = _AppThemePalette(
    background: Color(0xFF1C1410),
    card: Color(0xFF261C16),
    foreground: Color(0xFFF0E4D4),
    primary: Color(0xFFC69C6D),
    onPrimary: Color(0xFF1C1410),
    secondary: Color(0xFF3A2B20),
    accent: Color(0xFFE0A458),
    muted: Color(0xFF33261D),
    border: Color(0xFF4A382B),
  );

  static _AppThemePalette _paletteFor(AppThemeType type, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    switch (type) {
      case AppThemeType.defaultTheme:
        return isLight ? _defaultLight : _defaultDark;
      case AppThemeType.cafe:
        return isLight ? _cafeLight : _cafeDark;
    }
  }

  static Color _on(Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.dark
          ? Colors.white
          : Colors.black;

  static ThemeData light(AppThemeType type) =>
      _build(_paletteFor(type, Brightness.light), Brightness.light);

  static ThemeData dark(AppThemeType type) =>
      _build(_paletteFor(type, Brightness.dark), Brightness.dark);

  static ThemeData _build(_AppThemePalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      secondary: p.secondary,
      onSecondary: p.foreground,
      tertiary: p.accent,
      onTertiary: _on(p.accent),
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: p.card,
      onSurface: p.foreground,
      surfaceContainerLowest: p.background,
      surfaceContainer: p.muted,
      surfaceContainerHighest: p.muted,
      onSurfaceVariant: p.foreground.withValues(alpha: 0.72),
      outline: p.border,
      outlineVariant: p.border,
    );

    return ThemeData(
      brightness: brightness,
      fontFamily: kFontFamily,
      fontFamilyFallback: kFontFamilyFallback,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      dividerColor: p.border,
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: p.border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          backgroundColor: scheme.primary,
          surfaceTintColor: scheme.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: p.border, width: 0.5),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          backgroundColor: scheme.primary,
          surfaceTintColor: scheme.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          backgroundColor: Colors.transparent,
          side: BorderSide(color: scheme.primary.withValues(alpha: 0.6), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

final kLightMaterialAppTheme = AppThemeBuilder.light(AppThemeType.defaultTheme);
final kDarkMaterialAppTheme = AppThemeBuilder.dark(AppThemeType.defaultTheme);

const kLightCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xffffffff), color: Color(0xff000000)),
  'addition': TextStyle(backgroundColor: Color(0xffbaeeba)),
  'attr': TextStyle(color: Color(0xff836C28)),
  'attribute': TextStyle(color: Color(0xffaa0d91)),
  'built_in': TextStyle(color: Color(0xff5c2699)),
  'builtin-name': TextStyle(color: Color(0xff5c2699)),
  'bullet': TextStyle(color: Color(0xff1c00cf)),
  'code': TextStyle(color: Color(0xffc41a16)),
  'comment': TextStyle(color: Color(0xff007400), fontStyle: FontStyle.italic),
  'deletion': TextStyle(backgroundColor: Color(0xffffc8bd)),
  'doctag': TextStyle(fontWeight: FontWeight.bold),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'formula': TextStyle(
      backgroundColor: Color(0xffeeeeee), fontStyle: FontStyle.italic),
  'keyword': TextStyle(color: Color(0xffaa0d91)),
  'link': TextStyle(color: Color(0xff0E0EFF)),
  'literal': TextStyle(color: Color(0xffaa0d91)),
  'meta': TextStyle(color: Color(0xff643820)),
  'meta-string': TextStyle(color: Color(0xffc41a16)),
  'name': TextStyle(color: Color(0xffaa0d91)),
  'number': TextStyle(color: Color(0xff1c00cf)),
  'params': TextStyle(color: Color(0xff5c2699)),
  'quote': TextStyle(color: Color(0xff007400)),
  'regexp': TextStyle(color: Color(0xff0E0EFF)),
  'section': TextStyle(color: Color(0xff643820)),
  'selector-class': TextStyle(color: Color(0xff9b703f)),
  'selector-id': TextStyle(color: Color(0xff9b703f)),
  'selector-tag': TextStyle(color: Color(0xffaa0d91)),
  'string': TextStyle(color: Color(0xffc41a16)),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'subst': TextStyle(color: Color(0xff000000)),
  'symbol': TextStyle(color: Color(0xff1c00cf)),
  'tag': TextStyle(color: Color(0xffaa0d91)),
  'template-variable': TextStyle(color: Color(0xff3F6E74)),
  'title': TextStyle(color: Color(0xff1c00cf)),
  'type': TextStyle(color: Color(0xff5c2699)),
  'variable': TextStyle(color: Color(0xff3F6E74)),
};

const kDarkCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xff011627), color: Color(0xffd6deeb)),
  'addition': TextStyle(color: Color(0xffaddb67)),
  'attr': TextStyle(color: Color(0xff7fdbca)),
  'attribute': TextStyle(color: Color(0xff80cbc4)),
  'built_in': TextStyle(color: Color(0xffaddb67)),
  'builtin-name': TextStyle(color: Color(0xff7fdbca)),
  'bullet': TextStyle(color: Color(0xffd9f5dd)),
  'class': TextStyle(color: Color(0xffffcb8b)),
  'code': TextStyle(color: Color(0xff80CBC4)),
  'comment': TextStyle(color: Color(0xff637777), fontStyle: FontStyle.italic),
  'deletion': TextStyle(color: Color(0xffef5350)),
  'doctag': TextStyle(color: Color(0xff7fdbca)),
  'emphasis': TextStyle(color: Color(0xffc792ea)),
  'formula': TextStyle(color: Color(0xffc792ea), fontStyle: FontStyle.italic),
  'function': TextStyle(color: Color(0xff82AAFF)),
  'keyword': TextStyle(color: Color(0xffc792ea)),
  'link': TextStyle(color: Color(0xffff869a)),
  'literal': TextStyle(color: Color(0xffff5874)),
  'meta': TextStyle(color: Color(0xff82aaff)),
  'meta-keyword': TextStyle(color: Color(0xff82aaff)),
  'meta-string': TextStyle(color: Color(0xffecc48d)),
  'name': TextStyle(color: Color(0xff7fdbca)),
  'number': TextStyle(color: Color(0xffF78C6C)),
  'params': TextStyle(color: Color(0xff7fdbca)),
  'quote': TextStyle(color: Color(0xff697098)),
  'regexp': TextStyle(color: Color(0xff5ca7e4)),
  'section': TextStyle(color: Color(0xff82b1ff)),
  'selector-attr': TextStyle(color: Color(0xffc792ea)),
  'selector-class': TextStyle(color: Color(0xffaddb67)),
  'selector-id': TextStyle(color: Color(0xfffad430)),
  'selector-pseudo': TextStyle(color: Color(0xffc792ea)),
  'selector-tag': TextStyle(color: Color(0xffff6363)),
  'string': TextStyle(color: Color(0xffecc48d)),
  'strong': TextStyle(color: Color(0xffaddb67), fontWeight: FontWeight.bold),
  'subst': TextStyle(color: Color(0xffd3423e)),
  'symbol': TextStyle(color: Color(0xff82aaff)),
  'tag': TextStyle(color: Color(0xff7fdbca)),
  'template-tag': TextStyle(color: Color(0xffc792ea)),
  'template-variable': TextStyle(color: Color(0xffaddb67)),
  'title': TextStyle(color: Color(0xffDCDCAA)),
  'type': TextStyle(color: Color(0xff82aaff)),
  'variable': TextStyle(color: Color(0xffaddb67)),
};
