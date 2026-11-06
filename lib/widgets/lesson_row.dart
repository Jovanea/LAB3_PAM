import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_style.dart';

/// Un rand din lista de lectii (nodurile 1641:458 ... 1641:488 din Figma).
///
/// In design: cerc de 42 px, titlul la 102 px de marginea ecranului,
/// sageata portocalie in dreapta. Primul rand are cercul plin cu portocaliu.
class LessonRow extends StatelessWidget {
  const LessonRow({
    super.key,
    required this.lesson,
    this.highlighted = false,
    this.onTap,
  });

  final Lesson lesson;

  /// `true` pentru lectia curenta (cerc portocaliu, iconita alba).
  final bool highlighted;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            // Cercul cu iconita de redare
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: highlighted ? AppColors.accent : Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [AppShadows.smallPlay],
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 22,
                color: highlighted ? Colors.white : AppColors.accent,
              ),
            ),
            const SizedBox(width: 24),

            // Titlul lectiei si durata ei
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: kFontCourse,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.19,
                      color: AppColors.ink2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.duration} min',
                    style: const TextStyle(
                      fontFamily: kFontCourse,
                      fontSize: 16,
                      height: 1.19,
                      color: AppColors.duration,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
