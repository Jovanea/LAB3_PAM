import 'package:flutter/material.dart';

/// Toate valorile (culori, raze, umbre) sunt preluate 1:1 din Figma,
/// varianta 4 a laboratorului: frame-urile "Home-1" si "Course - Overview -1".
class AppColors {
  AppColors._();

  // ---------- Ecranul 1 (Home) ----------
  static const blue = Color(0xFF3D5CFF); // fundalul header-ului albastru
  static const ink = Color(0xFF1F1F39); // text principal inchis
  static const grey = Color(0xFF858597); // text secundar
  static const greyLight = Color(0xFFB8B8D2); // "/48", "/24"
  static const trackGrey = Color(0xFFF4F3FD); // bara/inelul de progres - fundal
  static const ringValue = Color(0xFF707070); // inelul de progres - valoare
  static const barEnd = Color(0xFFFF5106); // capatul gradientului barei
  static const adsBlue = Color(0xFFCEECFE); // fundalul casetelor din slider
  static const orange = Color(0xFFFF6905); // butonul "Get Started"

  // ---------- Ecranul 2 (Course Overview) ----------
  static const pageBg = Color(0xFFF9FBFF);
  static const ink2 = Color(0xFF2C2C2C);
  static const meta = Color(0xFF8C8C8C);
  static const duration = Color(0xFFAEAEAE);
  static const tabOff = Color(0xFFD2D2D2);
  static const accent = Color(0xFFFF7401);
  static const pillBg = Color(0xFFEAF4FF);
  static const star = Color(0xFFFFC71E);
  static const border = Color(0xFFF2F2F2);

  // ---------- Lab 3 (lista de cursuri) ----------
  // Variante mai inchise, ca textul mic sa fie lizibil pe alb (contrast >= 4.5:1).
  static const accentText = Color(0xFFC75000); // pretul cursului
  static const textMuted = Color(0xFF6E6E82); // autorul, durata, mesajele
}

class AppShadows {
  AppShadows._();

  /// Umbra cardurilor albe / mov de pe prima pagina.
  /// In Figma: dy 8, blur (stdDeviation) 6 => blurRadius 12, rgba(184,184,210,.2)
  static const card = BoxShadow(
    color: Color(0x33B8B8D2),
    offset: Offset(0, 8),
    blurRadius: 12,
  );

  /// Umbra cercului mare de "play" de pe pagina a doua.
  static const bigPlay = BoxShadow(
    color: Color(0x14132C4A),
    offset: Offset(0, 2),
    blurRadius: 20,
  );

  /// Umbra cercurilor mici din lista de lectii.
  static const smallPlay = BoxShadow(
    color: Color(0x0F132C4A),
    offset: Offset(0, 6),
    blurRadius: 10,
  );
}

/// Fontul folosit pe al doilea ecran (in Figma: Roboto / Inter).
/// Pe Android se rezolva la fontul de sistem, identic cu design-ul.
const String kFontCourse = 'Roboto';
