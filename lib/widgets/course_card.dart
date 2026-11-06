import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_style.dart';
import 'course_image.dart';
import 'favorite_button.dart';

/// Un element din lista de cursuri: miniatura, titlul, autorul,
/// durata, nota, pretul si butonul de favorite.
/// Stilul (alb, colturi 12, umbra) este cel al cardurilor din Figma.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  static const TextStyle _small = TextStyle(
    fontSize: 12,
    height: 1.5,
    color: AppColors.textMuted,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [AppShadows.card],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: CourseImage(course: course),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        course.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _small,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${course.durationLabel} · ${course.lessonsLabel}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _small,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.star,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            course.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: AppColors.ink,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            course.priceLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: AppColors.accentText,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
                FavoriteButton(courseId: course.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
