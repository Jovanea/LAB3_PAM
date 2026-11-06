import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/courses_cubit.dart';
import '../theme/app_style.dart';

/// Inimioara care adauga / scoate cursul din favorite.
/// Isi citeste singura starea din Cubit, deci poate fi pusa oriunde.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context) {
    final bool isFavorite =
        context.select((CoursesCubit c) => c.state.isFavorite(courseId));

    return IconButton(
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () => context.read<CoursesCubit>().toggleFavorite(courseId),
      icon: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFavorite ? AppColors.accent : AppColors.grey,
        size: 22,
      ),
    );
  }
}
