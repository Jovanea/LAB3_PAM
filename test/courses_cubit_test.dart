// Teste pentru logica listei (CoursesCubit), fara interfata.

import 'package:flutter_test/flutter_test.dart';
import 'package:lab_3_pam/cubit/courses_cubit.dart';
import 'package:lab_3_pam/cubit/courses_state.dart';
import 'package:lab_3_pam/data/course_repository.dart';
import 'package:lab_3_pam/models/course.dart';

/// Sursa de date falsa: intoarce ce ii dam, fara fisier si fara asteptare.
class FakeRepository implements CourseRepository {
  FakeRepository(this._load);

  final Future<List<Course>> Function() _load;

  @override
  Future<List<Course>> fetchCourses() => _load();
}

Course course(int id, String title, String category,
    {double rating = 4.5, double price = 0, int minutes = 60}) {
  return Course(
    id: id,
    title: title,
    category: category,
    author: 'Author $id',
    durationMinutes: minutes,
    rating: rating,
    price: price,
    description: '',
    lessons: const [],
  );
}

final List<Course> sample = [
  course(1, 'React', 'Development', rating: 4.9, price: 0, minutes: 390),
  course(2, 'Packaging Design', 'Design', rating: 4.7, price: 24.99, minutes: 300),
  course(3, 'Spoken English', 'Language', rating: 4.6, price: 10, minutes: 480),
  course(4, 'Flutter', 'Development', rating: 4.8, price: 39.99, minutes: 95),
];

Future<CoursesCubit> loadedCubit([List<Course>? data]) async {
  final cubit = CoursesCubit(FakeRepository(() async => data ?? sample));
  await cubit.loadCourses();
  return cubit;
}

List<int> ids(CoursesCubit c) => c.state.visible.map((e) => e.id).toList();

void main() {
  test('porneste in Loading, apoi Success cu lista sortata dupa nota', () async {
    final cubit = CoursesCubit(FakeRepository(() async => sample));
    expect(cubit.state.status, CoursesStatus.loading);

    await cubit.loadCourses();
    expect(cubit.state.status, CoursesStatus.success);
    expect(ids(cubit), [1, 4, 2, 3]);
    expect(cubit.state.categories, ['All', 'Development', 'Design', 'Language']);
  });

  test('Error cand sursa de date arunca exceptie, apoi revine la reincercare',
      () async {
    bool fail = true;
    final cubit = CoursesCubit(FakeRepository(() async {
      if (fail) throw const FormatException('JSON stricat');
      return sample;
    }));

    await cubit.loadCourses();
    expect(cubit.state.status, CoursesStatus.error);
    expect(cubit.state.errorMessage, isNotNull);

    fail = false;
    await cubit.loadCourses();
    expect(cubit.state.status, CoursesStatus.success);
  });

  test('Empty cand JSON-ul nu are cursuri', () async {
    final cubit = await loadedCubit([]);
    expect(cubit.state.status, CoursesStatus.empty);
  });

  test('cautarea ignora literele mari/mici si cauta si dupa autor', () async {
    final cubit = await loadedCubit();
    cubit.search('  ENGLISH ');
    expect(ids(cubit), [3]);

    cubit.search('author 2');
    expect(ids(cubit), [2]);

    cubit.search('nu exista');
    expect(cubit.state.status, CoursesStatus.empty);
    expect(cubit.state.visible, isEmpty);
  });

  test('filtrul de categorie si "Clear filters"', () async {
    final cubit = await loadedCubit();
    cubit.selectCategory('Development');
    expect(ids(cubit), [1, 4]);
    expect(cubit.state.hasFilters, isTrue);

    cubit.clearFilters();
    expect(ids(cubit), [1, 4, 2, 3]);
    expect(cubit.state.hasFilters, isFalse);
  });

  test('sortarea dupa pret, durata si titlu', () async {
    final cubit = await loadedCubit();
    cubit.sortBy(CourseSort.priceLow);
    expect(ids(cubit), [1, 3, 2, 4]);

    cubit.sortBy(CourseSort.duration);
    expect(ids(cubit), [4, 2, 1, 3]);

    cubit.sortBy(CourseSort.title);
    expect(ids(cubit), [4, 2, 1, 3]);
  });

  test('favorite: adaugare, filtrare, eliminare', () async {
    final cubit = await loadedCubit();
    cubit.toggleFavorite(2);
    cubit.toggleFavorite(3);
    expect(cubit.state.isFavorite(2), isTrue);

    cubit.showFavoritesOnly(true);
    expect(ids(cubit), [2, 3]);

    cubit.toggleFavorite(2);
    expect(ids(cubit), [3]);

    cubit.toggleFavorite(3);
    expect(cubit.state.status, CoursesStatus.empty);
  });

  test('filtrele alese in timpul incarcarii nu schimba starea Loading',
      () async {
    final cubit = CoursesCubit(FakeRepository(() async => sample));
    cubit.search('react');
    expect(cubit.state.status, CoursesStatus.loading);

    await cubit.loadCourses();
    expect(ids(cubit), [1]);
  });

  test('Course.fromJson citeste un curs si refuza campurile lipsa', () {
    final Course c = Course.fromJson({
      'id': 7,
      'title': 'UI Color Theory',
      'category': 'Design',
      'author': 'Jenny Wilson',
      'durationMinutes': 95,
      'rating': 4.4,
      'price': 0,
      'image': null,
      'description': 'd',
      'lessons': [
        {'title': 'Hue', 'duration': '09:10'},
      ],
    });
    expect(c.durationLabel, '1h 35min');
    expect(c.priceLabel, 'Free');
    expect(c.lessonsLabel, '1 lesson');
    expect(c.image, isNull);

    expect(() => Course.fromJson({'id': 1, 'title': 'Fara restul campurilor'}),
        throwsA(anything));
  });
}
