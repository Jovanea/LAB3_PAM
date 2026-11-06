import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/course.dart';
import '../theme/app_style.dart';
import '../widgets/course_image.dart';
import '../widgets/favorite_button.dart';
import '../widgets/lesson_row.dart';

/// ECRANUL 2 - "Course Overview" (frame-ul 1641:428 din Figma, varianta 4).
///
/// Pagina de detalii a cursului ales din lista. Toate datele vin din
/// obiectul [course], citit din JSON.
class CourseOverviewScreen extends StatefulWidget {
  const CourseOverviewScreen({super.key, required this.course});

  final Course course;

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  // --- Marginile din design (latimea artboard-ului Figma este 393 px) ---
  static const double _padLeft = 36;
  static const double _padRight = 22;

  /// Tab-ul activ: 0 = Lessons, 1 = Description.
  int _tab = 0;

  Course get _course => widget.course;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    // Inaltimea barei de jos (gradient + butoane), ca sa nu acopere continutul
    final double bottomBarHeight = 41 + 48 + 16 + mq.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Fundal deschis => iconitele barei de status sunt inchise la culoare
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBg,
        body: SafeArea(
          bottom: false,
          child: Stack(
            // Ocupa tot ecranul, ca bara de jos sa stea jos si cand
            // continutul e scurt (tab-ul Description).
            fit: StackFit.expand,
            children: [
              // ===================== CONTINUTUL DERULABIL =====================
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomBarHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 3),
                    _buildAppBar(),

                    const SizedBox(height: 44),

                    // -------- Imaginea cursului + butonul mare de "play" --------
                    Padding(
                      padding: const EdgeInsets.only(
                        left: _padLeft,
                        right: _padRight,
                      ),
                      child: AspectRatio(
                        aspectRatio: 335 / 207,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CourseImage(
                                course: _course,
                                radius: 14,
                                iconSize: 44,
                                iconAlignment: Alignment.topLeft,
                              ),
                            ),
                            _buildBigPlayButton(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    // -------------------- Titlul cursului --------------------
                    Padding(
                      padding: const EdgeInsets.only(
                        left: _padLeft,
                        right: _padRight,
                      ),
                      child: Text(
                        _course.title,
                        style: const TextStyle(
                          fontFamily: kFontCourse,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.15,
                          color: AppColors.ink2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ------------- Durata, numarul de lectii, nota -------------
                    Padding(
                      padding: const EdgeInsets.only(
                        left: _padLeft,
                        right: _padRight,
                      ),
                      child: _MetaRow(course: _course),
                    ),

                    const SizedBox(height: 22),

                    // ------------------ Tab-urile + linia activa ------------------
                    _buildTabs(),

                    const SizedBox(height: 26),

                    // ------------------- Continutul tab-ului -------------------
                    ..._buildTabContent(),
                  ],
                ),
              ),

              // ============ BARA DE JOS: gradient + butoanele de actiune ============
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomBar(mq.padding.bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Lista de widget-uri afisata sub tab-uri (lectii sau descriere).
  List<Widget> _buildTabContent() {
    if (_tab == 1) {
      return [
        Padding(
          padding: const EdgeInsets.only(left: _padLeft, right: _padRight),
          child: Text(
            _course.description,
            style: const TextStyle(
              fontFamily: kFontCourse,
              fontSize: 16,
              height: 1.6,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ];
    }

    final List<Widget> rows = [];
    for (int i = 0; i < _course.lessons.length; i++) {
      if (i > 0) rows.add(const SizedBox(height: 28));
      rows.add(
        Padding(
          // sageata din dreapta se opreste la x=361 in design (393 - 32)
          padding: const EdgeInsets.only(left: _padLeft, right: 32),
          child: LessonRow(
            lesson: _course.lessons[i],
            highlighted: i == 0,
          ),
        ),
      );
    }
    return rows;
  }

  // --------------------------- Bara de sus ---------------------------
  Widget _buildAppBar() {
    return SizedBox(
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Sageata de intoarcere (cadru de 40x40 la x=11 in design)
          Positioned(
            left: 11,
            top: 0,
            width: 40,
            height: 40,
            child: IconButton(
              tooltip: 'Back',
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 21,
                color: Colors.black,
              ),
            ),
          ),
          // Titlul incepe la x=42 in design
          const Positioned(
            left: 42,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                'Course Overview',
                style: TextStyle(
                  fontFamily: kFontCourse,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink2,
                ),
              ),
            ),
          ),
          // Inimioara de favorite (adaugata in lab 3)
          Positioned(
            right: 10,
            top: -4,
            child: FavoriteButton(courseId: _course.id),
          ),
        ],
      ),
    );
  }

  // ------------------ Butonul mare de "play" de pe imagine ------------------
  Widget _buildBigPlayButton() {
    return Container(
      width: 54,
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [AppShadows.bigPlay],
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        size: 30,
        color: AppColors.accent,
      ),
    );
  }

  // ------------------------ Tab-urile Lessons / Description ------------------------
  Widget _buildTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 21,
          child: Row(
            children: [
              const SizedBox(width: 113),
              _tabLabel('Lessons', 0),
              const SizedBox(width: 36),
              _tabLabel('Description', 1),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Linia portocalie de sub tab-ul activ (100 x 2 in design)
        SizedBox(
          height: 2,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                left: _tab == 0 ? 97 : 213.5,
                top: 0,
                child: Container(
                  width: 100,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabLabel(String text, int index) {
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      behavior: HitTestBehavior.opaque,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: kFontCourse,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.17,
          color: _tab == index ? AppColors.accent : AppColors.tabOff,
        ),
      ),
    );
  }

  // ------------------------ Bara de jos cu butoane ------------------------
  Widget _buildBottomBar(double safeBottom) {
    return Container(
      padding: EdgeInsets.only(
        left: _padLeft,
        right: _padRight,
        top: 41,
        bottom: 16 + safeBottom,
      ),
      decoration: const BoxDecoration(
        // Estompeaza lista de lectii pe sub butoane, exact ca in design
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCEF9FBFF), AppColors.pageBg],
          stops: [0.05, 0.575],
        ),
      ),
      child: Row(
        children: [
          // Pretul ("Free" in design)
          Container(
            constraints: const BoxConstraints(minWidth: 70),
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.all(Radius.circular(14)),
            ),
            child: Text(
              _course.priceLabel,
              style: const TextStyle(
                fontFamily: kFontCourse,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Butonul "Enroll Now"
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: const Text(
                'Enroll Now',
                style: TextStyle(
                  fontFamily: kFontCourse,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Randul cu durata cursului, numarul de lectii si nota.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    const TextStyle metaStyle = TextStyle(
      fontFamily: kFontCourse,
      fontSize: 14.28,
      height: 1.19,
      color: AppColors.meta,
    );

    return SizedBox(
      height: 24,
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, size: 14.28, color: AppColors.meta),
          const SizedBox(width: 4),
          Text(course.durationLabel, style: metaStyle),
          const SizedBox(width: 8),
          Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
              color: AppColors.meta,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(course.lessonsLabel, style: metaStyle),
          const Spacer(),
          // Eticheta cu nota
          Container(
            height: 24,
            padding: const EdgeInsets.only(left: 6, right: 7),
            decoration: const BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 20, color: AppColors.star),
                const SizedBox(width: 2),
                Text(
                  course.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontFamily: kFontCourse,
                    fontSize: 14.28,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accent,
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
