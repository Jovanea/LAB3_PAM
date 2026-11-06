# Lab 3 PAM — Online Course App (State Management + JSON)

Aplicație Flutter după designul din Figma (varianta 4: „Home-1” și
„Course - Overview -1”). Lista de cursuri este citită asincron dintr-un
fișier JSON inclus în proiect, iar starea aplicației este gestionată cu
**Cubit** din pachetul `flutter_bloc`.

## Funcționalități

- **Încărcare asincronă** a datelor din `assets/data/courses.json`
  (`rootBundle.loadString` + `jsonDecode`), cu o mică întârziere care imită o cerere prin rețea
- **Stările ecranului:** Loading (carduri „schelet”), Success (lista),
  Empty (niciun rezultat, cu buton „Clear filters”), Error (mesaj + „Try again”)
- **Căutare** după titlu, autor sau categorie (fără diferență între litere mari și mici)
- **Filtrare** pe categorii (generate din date) și filtrul „Favorites”
- **Sortare:** după notă, preț, durată sau titlu
- **Favorite:** adăugare și eliminare din listă și din pagina de detalii
  (păstrate în memorie, cât timp aplicația e deschisă)
- **Navigare** spre pagina de detalii a cursului (lecții, descriere, preț)

## Structură

```
assets/data/courses.json        — datele aplicației (10 cursuri)
lib/main.dart                   — tema și BlocProvider (un Cubit pentru toată aplicația)
lib/models/course.dart          — modelele Course și Lesson (fromJson)
lib/data/course_repository.dart — citirea asincronă a fișierului JSON
lib/cubit/courses_state.dart    — starea: status, date, filtre, favorite
lib/cubit/courses_cubit.dart    — logica: încărcare, căutare, filtrare, sortare, favorite
lib/screens/                    — ecranele Home și Course Overview
lib/widgets/                    — componente reutilizabile (card curs, căutare,
                                  filtre, sortare, favorite, stări Loading/Empty/Error)
lib/theme/app_style.dart        — culorile și umbrele din Figma
test/                           — teste pentru Cubit și pentru ecrane
```

## Rulare

```bash
flutter pub get
flutter run
```

## Verificare

```bash
flutter analyze   # fără probleme
flutter test      # 11 teste: Cubit (stări, filtre, sortare, favorite) + ecrane
```
