import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/course_repository.dart';
import '../models/course.dart';
import 'courses_state.dart';

/// Toata logica listei de cursuri: incarcare, cautare, filtrare,
/// sortare si favorite. Ecranele doar afiseaza starea si apeleaza metodele.
class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit(this._repository) : super(const CoursesState());

  final CourseRepository _repository;

  /// Incarca (sau reincarca) cursurile din JSON.
  Future<void> loadCourses() async {
    emit(state.copyWith(status: CoursesStatus.loading));
    try {
      final List<Course> courses = await _repository.fetchCourses();
      if (isClosed) return;
      _apply(state.copyWith(all: courses, status: CoursesStatus.success));
    } catch (e) {
      debugPrint('Eroare la citirea cursurilor: $e');
      if (isClosed) return;
      emit(state.copyWith(
        status: CoursesStatus.error,
        errorMessage: 'The course list could not be read. Tap "Try again".',
      ));
    }
  }

  void search(String query) => _apply(state.copyWith(query: query.trim()));

  void selectCategory(String category) =>
      _apply(state.copyWith(category: category));

  void showFavoritesOnly(bool value) =>
      _apply(state.copyWith(favoritesOnly: value));

  void sortBy(CourseSort sort) => _apply(state.copyWith(sort: sort));

  void clearFilters() => _apply(state.copyWith(
        query: '',
        category: CoursesState.allCategories,
        favoritesOnly: false,
      ));

  /// Adauga cursul la favorite sau il scoate, daca era deja.
  void toggleFavorite(int id) {
    final Set<int> ids = {...state.favoriteIds};
    if (!ids.remove(id)) ids.add(id);
    _apply(state.copyWith(favoriteIds: ids));
  }

  /// Recalculeaza lista vizibila si alege intre Success si Empty.
  void _apply(CoursesState next) {
    // Cat timp datele nu au venit, doar retinem filtrele alese.
    if (next.status == CoursesStatus.loading ||
        next.status == CoursesStatus.error) {
      emit(next);
      return;
    }
    final List<Course> visible = _filterAndSort(next);
    emit(next.copyWith(
      visible: visible,
      status: visible.isEmpty ? CoursesStatus.empty : CoursesStatus.success,
    ));
  }

  static List<Course> _filterAndSort(CoursesState s) {
    final String q = s.query.toLowerCase();
    final List<Course> result = s.all.where((c) {
      if (s.favoritesOnly && !s.favoriteIds.contains(c.id)) return false;
      if (s.category != CoursesState.allCategories && c.category != s.category) {
        return false;
      }
      return q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.author.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q);
    }).toList();

    result.sort((a, b) {
      final int byOption = switch (s.sort) {
        CourseSort.rating => b.rating.compareTo(a.rating),
        CourseSort.priceLow => a.price.compareTo(b.price),
        CourseSort.duration => a.durationMinutes.compareTo(b.durationMinutes),
        CourseSort.title => 0,
      };
      // La egalitate (si pentru "Title A-Z") ordonam dupa titlu.
      return byOption != 0
          ? byOption
          : a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return result;
  }
}
