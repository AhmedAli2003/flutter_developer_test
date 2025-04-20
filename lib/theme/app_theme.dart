import 'package:flutter/material.dart';
import 'package:flutter_developer_test/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static final theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      color: AppColors.white,
      toolbarHeight: 90,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColors.primary,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.publicSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.98,
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.publicSans(
        color: AppColors.bodyText,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.98,
      ),
      bodySmall: GoogleFonts.publicSans(
        color: AppColors.greyText,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.98,
      ),
      titleLarge: GoogleFonts.publicSans(
        color: AppColors.secondary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.98,
      ),
      titleMedium: GoogleFonts.publicSans(
        color: AppColors.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.98,
      ),
      labelMedium: GoogleFonts.publicSans(
        color: AppColors.secondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.98,
      ),
      labelSmall: GoogleFonts.publicSans(
        color: AppColors.bodyText,
        fontSize: 16,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.98,
      ),
    ),
  );
}
