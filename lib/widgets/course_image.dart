import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_style.dart';

/// Imaginea cursului. Daca in JSON nu exista imagine, afiseaza un
/// fundal colorat dupa categorie, cu iconita categoriei.
/// Folosita si in lista (miniatura), si pe ecranul de detalii (coperta).
class CourseImage extends StatelessWidget {
  const CourseImage({
    super.key,
    required this.course,
    this.radius = 10,
    this.iconSize = 30,
    this.iconAlignment = Alignment.center,
  });

  final Course course;
  final double radius;
  final double iconSize;

  /// Pe coperta mare iconita sta intr-un colt, ca sa nu fie sub butonul play.
  final Alignment iconAlignment;

  /// Fundal, culoarea iconitei si iconita pentru fiecare categorie.
  static const Map<String, (Color, Color, IconData)> _categoryStyle = {
    'Development': (Color(0xFFE8ECFF), AppColors.blue, Icons.code_rounded),
    'Design': (Color(0xFFFFEEDF), Color(0xFFD45F00), Icons.brush_rounded),
    'Language': (AppColors.adsBlue, Color(0xFF1A6FA3), Icons.translate_rounded),
    'Marketing': (Color(0xFFF0E8FF), Color(0xFF6E45C7), Icons.campaign_rounded),
    'Business': (Color(0xFFE3F5EA), Color(0xFF237A4B), Icons.work_rounded),
  };

  @override
  Widget build(BuildContext context) {
    final String? image = course.image;
    final (Color bg, Color fg, IconData icon) = _categoryStyle[course.category] ??
        (AppColors.trackGrey, AppColors.ink, Icons.school_rounded);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: image != null
          ? Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              // Daca imaginea lipseste din assets, aratam fundalul categoriei.
              errorBuilder: (_, _, _) => _placeholder(bg, fg, icon),
            )
          : _placeholder(bg, fg, icon),
    );
  }

  Widget _placeholder(Color bg, Color fg, IconData icon) {
    return ColoredBox(
      color: bg,
      child: Padding(
        padding: EdgeInsets.all(iconSize / 3),
        child: Align(
          alignment: iconAlignment,
          child: Icon(icon, color: fg, size: iconSize),
        ),
      ),
    );
  }
}
