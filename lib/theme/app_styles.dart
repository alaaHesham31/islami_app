
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami_app_demo/theme/app_colors.dart';

class AppStyles {
  static TextStyle bold16White = GoogleFonts.notoKufiArabic(
    fontSize: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w700,);

  static TextStyle semi16White = GoogleFonts.notoKufiArabic(
    fontSize: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w500,);

    static TextStyle bold18White = GoogleFonts.notoKufiArabic(
    fontSize: 20, color: AppColors.whiteColor, fontWeight: FontWeight.w400,);

    static TextStyle semi18White = GoogleFonts.notoKufiArabic(
    fontSize: 18, color: AppColors.whiteColor, fontWeight: FontWeight.w500,);

  static TextStyle semi20Brown = GoogleFonts.notoKufiArabic(
    fontSize: 20, color: AppColors.brownColor, fontWeight: FontWeight.w500,);

  static TextStyle semi16Black = GoogleFonts.notoKufiArabic(
    fontSize: 16, color: AppColors.blackColor, fontWeight: FontWeight.w500,);


  static TextStyle bold16Primary = GoogleFonts.notoKufiArabic(
    fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.w700,);
}
