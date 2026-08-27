import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// Asks whether the next scan should come from the camera or the gallery.
///
/// Returns the chosen [ImageSource], or `null` when the sheet is dismissed
/// without a choice - callers treat that the same way they treat the picker
/// itself being cancelled.
Future<ImageSource?> askImageSource({
  String title = "Scan a question",
  String cameraSubtitle = "Point at the question and shoot",
  String gallerySubtitle = "Pick a photo you already have",
}) {
  return Get.bottomSheet<ImageSource>(
    Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        // The pages behind this sheet all run the same purple-to-pink body
        // gradient, so the sheet takes the deep end of it and lets the bright
        // tiles carry the colour -- that keeps the two layers apart.
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20.r,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grab handle
          Container(
            width: 44.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 4.r,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          _SourceTile(
            icon: Icons.camera_alt_rounded,
            label: "Camera",
            subtitle: cameraSubtitle,
            colors: const [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            onTap: () => Get.back(result: ImageSource.camera),
          ),
          SizedBox(height: 14.h),
          _SourceTile(
            icon: Icons.photo_library_rounded,
            label: "Gallery",
            subtitle: gallerySubtitle,
            colors: const [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
            onTap: () => Get.back(result: ImageSource.gallery),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.45),
                blurRadius: 12.r,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(11.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26.r),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.baloo2(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.nunito(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 24.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
