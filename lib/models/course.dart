/// O lectie a cursului (titlul si durata, de ex. "04:28").
class Lesson {
  const Lesson({required this.title, required this.duration});

  final String title;
  final String duration;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'] as String,
      duration: json['duration'] as String,
    );
  }
}

/// Un curs, asa cum este descris in assets/data/courses.json.
///
/// `fromJson` arunca exceptie daca lipseste un camp sau are alt tip;
/// Cubit-ul o prinde si afiseaza starea de eroare.
class Course {
  const Course({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.durationMinutes,
    required this.rating,
    required this.price,
    required this.description,
    required this.lessons,
    this.image,
  });

  final int id;
  final String title;
  final String category;
  final String author;
  final int durationMinutes;
  final double rating;

  /// Pretul in dolari; 0 inseamna curs gratuit.
  final double price;
  final String description;
  final List<Lesson> lessons;

  /// Calea spre imaginea din assets; `null` daca cursul nu are imagine.
  final String? image;

  bool get isFree => price == 0;

  String get priceLabel => isFree ? 'Free' : '\$${price.toStringAsFixed(2)}';

  /// 390 -> "6h 30min", 45 -> "45min", 120 -> "2h".
  String get durationLabel {
    final int h = durationMinutes ~/ 60;
    final int m = durationMinutes % 60;
    if (h == 0) return '${m}min';
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  String get lessonsLabel =>
      lessons.length == 1 ? '1 lesson' : '${lessons.length} lessons';

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      author: json['author'] as String,
      durationMinutes: json['durationMinutes'] as int,
      rating: (json['rating'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String?,
    );
  }
}
