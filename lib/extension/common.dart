import 'package:flutter/material.dart';
import 'package:http/http.dart';

extension SuccessExt on Response {
  bool get success {
    return statusCode >= 200 && statusCode < 300;
  }
}

enum LayoutMode { mobile, tablet, desktop }

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;

  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

extension AppSpacingExtension on BuildContext {
  LayoutMode _layoutMode() {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 1200) return .desktop;
    if (width >= 600) return .tablet;
    return .mobile;
  }

  LayoutMode get layoutMode => _layoutMode();

  double _scale(double m, double t, double d) {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 1200) return d;
    if (width >= 600) return t;
    return m; // mobile
  }

  double get xs => 4;

  double get sm => 8;

  double get md => _scale(16, 20, 24);

  double get lg => _scale(24, 28, 32);

  double get xl => _scale(32, 40, 48);
}
