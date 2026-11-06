import '../models/course.dart';

/// Starile principale ale ecranului cu lista de cursuri.
enum CoursesStatus { loading, success, empty, error }

/// Variantele de sortare, cu textul afisat in meniu.
enum CourseSort {
  rating('Top rated'),
  priceLow('Price: low to high'),
  duration('Shortest first'),
  title('Title A-Z');

  const CourseSort(this.label);
  final String label;
}

/// Starea completa a listei: datele din JSON, filtrele alese si
/// rezultatul lor (`visible`), calculat de Cubit.
class CoursesState {
  const CoursesState({
    this.status = CoursesStatus.loading,
    this.all = const [],
    this.visible = const [],
    this.query = '',
    this.category = allCategories,
    this.favoritesOnly = false,
    this.sort = CourseSort.rating,
    this.favoriteIds = const {},
    this.errorMessage,
  });

  /// Valoarea filtrului de categorie care arata toate cursurile.
  static const String allCategories = 'All';

  final CoursesStatus status;
  final List<Course> all;
  final List<Course> visible;
  final String query;
  final String category;
  final bool favoritesOnly;
  final CourseSort sort;
  final Set<int> favoriteIds;
  final String? errorMessage;

  /// "All" + categoriile din date, in ordinea in care apar in JSON.
  List<String> get categories => [
        allCategories,
        ...{for (final c in all) c.category},
      ];

  bool get hasFilters =>
      query.isNotEmpty || category != allCategories || favoritesOnly;

  bool isFavorite(int id) => favoriteIds.contains(id);

  CoursesState copyWith({
    CoursesStatus? status,
    List<Course>? all,
    List<Course>? visible,
    String? query,
    String? category,
    bool? favoritesOnly,
    CourseSort? sort,
    Set<int>? favoriteIds,
    String? errorMessage,
  }) {
    return CoursesState(
      status: status ?? this.status,
      all: all ?? this.all,
      visible: visible ?? this.visible,
      query: query ?? this.query,
      category: category ?? this.category,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
