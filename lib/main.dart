import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/courses_cubit.dart';
import 'data/course_repository.dart';
import 'screens/home_screen.dart';

// Punctul de intrare in aplicatie
void main() {
  runApp(const OnlineCourseApp());
}

/// Configurarea generala a aplicatiei.
///
/// [BlocProvider] creeaza un singur CoursesCubit pentru toata aplicatia si
/// porneste imediat incarcarea asincrona a cursurilor din JSON. Fiind deasupra
/// lui MaterialApp, acelasi Cubit este vazut si de ecranul de detalii.
class OnlineCourseApp extends StatelessWidget {
  const OnlineCourseApp({
    super.key,
    this.repository = const CourseRepository(),
  });

  /// Sursa datelor; testele pot pune aici o sursa falsa.
  final CourseRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesCubit(repository)..loadCourses(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Online Course App',
        theme: ThemeData(
          useMaterial3: true,
          // Fontul din design-ul Figma
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D5CFF)),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
