import 'package:flutter/material.dart';

import '../cubit/courses_state.dart';
import '../theme/app_style.dart';

/// Butonul de sortare: arata criteriul curent si deschide meniul.
class SortMenu extends StatelessWidget {
  const SortMenu({super.key, required this.current, required this.onSelected});

  final CourseSort current;
  final ValueChanged<CourseSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CourseSort>(
      tooltip: 'Sort courses',
      initialValue: current,
      onSelected: onSelected,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      itemBuilder: (_) => [
        for (final CourseSort s in CourseSort.values)
          CheckedPopupMenuItem<CourseSort>(
            value: s,
            checked: s == current,
            child: Text(s.label),
          ),
      ],
      child: Padding(
        // Zona de apasare de minim 44 px inaltime
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert_rounded, size: 18, color: AppColors.blue),
            const SizedBox(width: 4),
            Text(
              current.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
