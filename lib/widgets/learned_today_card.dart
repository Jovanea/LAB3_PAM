import 'package:flutter/material.dart';

import '../theme/app_style.dart';

/// Cardul alb "Learned today" de pe prima pagina (nodul 3:1584 din Figma).
///
/// In design: 335 x 96, colturi rotunjite 12, umbra (0, 8, blur 12).
class LearnedTodayCard extends StatelessWidget {
  const LearnedTodayCard({
    super.key,
    required this.minutes,
    required this.goalMinutes,
    this.onMyCourses,
  });

  /// Minutele invatate azi.
  final int minutes;

  /// Obiectivul zilnic, in minute.
  final int goalMinutes;

  /// Apelat la apasarea pe "My courses".
  final VoidCallback? onMyCourses;

  @override
  Widget build(BuildContext context) {
    // Cat din obiectiv a fost realizat (folosit pentru latimea barei)
    final double progress = (minutes / goalMinutes).clamp(0.0, 1.0);

    return Container(
      height: 96,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [AppShadows.card],
      ),
      padding: const EdgeInsets.only(left: 16, right: 15, top: 20, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Randul de sus: eticheta + link-ul "My courses" ---
          Row(
            children: [
              const Text(
                'Learned today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onMyCourses,
                behavior: HitTestBehavior.opaque,
                child: const Text(
                  'My courses',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // --- Minutele invatate / obiectivul ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${minutes}min',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '/ ${goalMinutes}min',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          // --- Bara de progres (303 x 6 in design, gradient spre portocaliu) ---
          SizedBox(
            height: 6,
            child: Stack(
              children: [
                // Fundalul barei
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.trackGrey,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
                // Portiunea parcursa
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      gradient: LinearGradient(
                        // alb transparent -> portocaliu, exact ca in Figma
                        colors: [Color(0x00FFFFFF), AppColors.barEnd],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
