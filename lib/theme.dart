import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    final flavor = //
        catppuccin.latte;
    Color primaryColor = flavor.mauve;
    Color secondaryColor = flavor.pink;

    final T = ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: flavor.text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: flavor.crust,
        foregroundColor: flavor.mantle,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        error: flavor.surface2,
        onError: flavor.red,
        onPrimary: primaryColor,
        onSecondary: secondaryColor,
        onSurface: flavor.text,
        primary: flavor.crust,
        secondary: flavor.mantle,
        surface: flavor.base,
      ),
      textTheme: textTheme(Brightness.light, flavor),
    );

    return common(primaryColor, secondaryColor, T, flavor);
  }

  static ThemeData dark() {
    final flavor = //
        catppuccin.macchiato;
    Color primaryColor = flavor.maroon;
    Color secondaryColor = flavor.pink;
    final T = ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: flavor.text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: flavor.crust,
        foregroundColor: flavor.mantle,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        error: flavor.surface2,
        onError: flavor.red,
        onPrimary: primaryColor,
        onSecondary: secondaryColor,
        onSurface: flavor.text,
        primary: flavor.crust,
        secondary: flavor.mantle,
        surface: flavor.surface0,
      ),
      textTheme: textTheme(Brightness.light, flavor),
    );

    return common(primaryColor, secondaryColor, T, flavor);
  }

  static ThemeData common(
    Color primaryColor,
    Color secondaryColor,
    ThemeData themeData,
    Flavor flavor,
  ) {
    return themeData.copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        shape: CircleBorder(),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        color: flavor.mantle,
      ),

      // scaffoldBackgroundColor: flavor.base,
      // iconTheme: IconThemeData(color: primaryColor),
      drawerTheme: DrawerThemeData(),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: WidgetStateColor.fromMap({
            WidgetState.hovered: themeData.colorScheme.onPrimary.withAlpha(25),
            WidgetState.any: themeData.colorScheme.surface,
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: .circular(4)),
          ),
        ),
      ),
    );
  }

  static TextTheme textTheme(Brightness brightness, Flavor flavor) {
    final lora = GoogleFonts.lora();

    return GoogleFonts.manropeTextTheme(
          ThemeData(brightness: brightness).textTheme,
        )
        .copyWith(
          displayLarge: lora,
          displayMedium: lora,
          headlineLarge: lora,
          headlineMedium: lora,
        )
        .apply(displayColor: flavor.text, bodyColor: flavor.subtext0);
  }
}
