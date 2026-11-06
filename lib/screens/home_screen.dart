import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/courses_cubit.dart';
import '../cubit/courses_state.dart';
import '../models/course.dart';
import '../theme/app_style.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_bar.dart';
import '../widgets/learned_today_card.dart';
import '../widgets/search_field.dart';
import '../widgets/sort_menu.dart';
import '../widgets/status_views.dart';
import 'course_overview_screen.dart';

/// ECRANUL 1 - "Home": header-ul din Figma (varianta 4) + catalogul de
/// cursuri incarcat din JSON, cu cautare, filtre, sortare si favorite.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _pagePad = 20;

  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openCourse(Course course) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CourseOverviewScreen(course: course),
      ),
    );
  }

  void _clearFilters() {
    _search.clear();
    context.read<CoursesCubit>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final CoursesCubit cubit = context.read<CoursesCubit>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Iconitele barei de status sunt albe peste header-ul albastru
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<CoursesCubit, CoursesState>(
          builder: (context, state) {
            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    onMyCourses: () => cubit.showFavoritesOnly(true),
                  ),
                ),

                // ------------------- Cautarea -------------------
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(_pagePad, 20, _pagePad, 0),
                  sliver: SliverToBoxAdapter(
                    child: SearchField(
                      controller: _search,
                      onChanged: cubit.search,
                    ),
                  ),
                ),

                // ------------- Titlul sectiunii + sortarea -------------
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(_pagePad, 16, 12, 4),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        const Text(
                          'Courses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (state.status == CoursesStatus.success)
                          Text(
                            '${state.visible.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        const Spacer(),
                        SortMenu(current: state.sort, onSelected: cubit.sortBy),
                      ],
                    ),
                  ),
                ),

                // ------------------- Filtrele -------------------
                SliverToBoxAdapter(
                  child: FilterBar(
                    categories: state.categories,
                    selectedCategory: state.category,
                    favoritesOnly: state.favoritesOnly,
                    onCategorySelected: cubit.selectCategory,
                    onFavoritesChanged: cubit.showFavoritesOnly,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                // ------------- Continutul, dupa starea curenta -------------
                ..._buildBody(state, cubit),

                SliverToBoxAdapter(
                  child: SizedBox(height: 24 + MediaQuery.paddingOf(context).bottom),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBody(CoursesState state, CoursesCubit cubit) {
    switch (state.status) {
      case CoursesStatus.loading:
        return const [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: _pagePad),
            sliver: SliverToBoxAdapter(child: CourseListSkeleton()),
          ),
        ];

      case CoursesStatus.error:
        return [
          SliverToBoxAdapter(
            child: MessageView(
              icon: Icons.error_outline_rounded,
              title: 'Couldn\'t load courses',
              message: state.errorMessage ?? 'Something went wrong.',
              actionLabel: 'Try again',
              onAction: cubit.loadCourses,
            ),
          ),
        ];

      case CoursesStatus.empty:
        return [SliverToBoxAdapter(child: _buildEmpty(state))];

      case CoursesStatus.success:
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: _pagePad),
            sliver: SliverList.separated(
              itemCount: state.visible.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (_, i) {
                final Course course = state.visible[i];
                return CourseCard(
                  key: ValueKey(course.id),
                  course: course,
                  onTap: () => _openCourse(course),
                );
              },
            ),
          ),
        ];
    }
  }

  /// Mesajul pentru starea Empty explica de ce lista e goala.
  Widget _buildEmpty(CoursesState state) {
    if (state.all.isEmpty) {
      return const MessageView(
        icon: Icons.school_outlined,
        title: 'No courses yet',
        message: 'New courses will appear here as soon as they are added.',
      );
    }
    if (state.favoritesOnly && state.favoriteIds.isEmpty) {
      return MessageView(
        icon: Icons.favorite_border_rounded,
        title: 'No favorites yet',
        message: 'Tap the heart on a course to save it here.',
        actionLabel: 'Show all courses',
        onAction: _clearFilters,
      );
    }
    return MessageView(
      icon: Icons.search_off_rounded,
      title: 'No courses found',
      message: state.query.isEmpty
          ? 'Nothing matches the selected filters.'
          : 'Nothing matches "${state.query}". Try another word or category.',
      actionLabel: 'Clear filters',
      onAction: _clearFilters,
    );
  }
}

/// Header-ul albastru din Figma: salutul, avatarul si cardul "Learned today".
class _Header extends StatelessWidget {
  const _Header({required this.onMyCourses});

  final VoidCallback onMyCourses;

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        // Fundalul albastru (183 px in design, din care 44 bara de status)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: top + 139,
          child: const ColoredBox(color: AppColors.blue),
        ),
        Padding(
          padding: EdgeInsets.only(top: top),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 93,
                child: Stack(
                  children: [
                    const Positioned(
                      left: 20,
                      top: 17,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Kristin',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Let’s start learning',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 21,
                      top: 7,
                      child: Image.asset(
                        'assets/images/avatar.png',
                        width: 36,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LearnedTodayCard(
                  minutes: 46,
                  goalMinutes: 60,
                  onMyCourses: onMyCourses,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
