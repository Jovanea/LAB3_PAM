// Teste pentru aplicatie, cu fisierul JSON adevarat din assets.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_3_pam/main.dart';
import 'package:lab_3_pam/widgets/status_views.dart';

import 'helpers/load_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  // rootBundle tine JSON-ul in cache intre teste; Future-ul din cache apartine
  // timpului fals al testului anterior si n-ar mai termina niciodata.
  setUp(rootBundle.clear);

  // Ecran de telefon (393 x 852), ca in Figma
  void phoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('Loading -> lista din JSON -> cautare -> Empty -> Clear filters',
      (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(const OnlineCourseApp());

    // Starea Loading: scheletul listei
    expect(find.byType(CourseListSkeleton), findsOneWidget);

    // Dupa ~800 ms datele din courses.json sunt pe ecran
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(CourseListSkeleton), findsNothing);
    expect(find.text('React Front To back'), findsOneWidget);
    expect(find.text('10'), findsOneWidget); // numarul de cursuri

    await tester.enterText(find.byType(TextField), 'english');
    await tester.pumpAndSettle();
    expect(find.text('Spoken English'), findsOneWidget);
    expect(find.text('Business English'), findsOneWidget);
    expect(find.text('React Front To back'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('No courses found'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('React Front To back'), findsOneWidget);
    expect(find.text('zzz'), findsNothing); // si campul de cautare s-a golit
  });

  testWidgets('detaliile cursului si favoritele', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(const OnlineCourseApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Deschide cursul din lista
    await tester.tap(find.text('React Front To back'));
    await tester.pumpAndSettle();
    expect(find.text('Course Overview'), findsOneWidget);
    expect(find.text('Introduction to React'), findsOneWidget);
    expect(find.text('7 lessons'), findsOneWidget);

    // Adauga la favorite din pagina de detalii
    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    // Inapoi pe Home: filtrul "Favorites" arata doar acest curs
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('React Front To back'), findsOneWidget);
    expect(find.text('Packaging Design'), findsNothing);
  });
}
