import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

/// Sursa de date a aplicatiei: fisierul JSON inclus in proiect.
class CourseRepository {
  const CourseRepository();

  static const String _asset = 'assets/data/courses.json';

  /// Citeste si transforma lista de cursuri, asincron.
  Future<List<Course>> fetchCourses() async {
    // Imita o cerere prin retea, ca starea Loading sa se vada pe ecran.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final String raw = await rootBundle.loadString(_asset);
    final List<dynamic> items = jsonDecode(raw) as List<dynamic>;
    return items
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
