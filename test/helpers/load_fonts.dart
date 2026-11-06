import 'dart:io';

import 'package:flutter/services.dart';

/// In teste Flutter deseneaza implicit fiecare litera ca un patrat lat,
/// asa ca textele par mult mai lungi decat pe telefon. Incarcam fonturile
/// reale: Poppins (din proiect), Roboto si iconitele Material (din SDK).
Future<void> loadAppFonts() async {
  final String sdkFonts =
      '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';

  Future<void> load(String family, List<String> paths) async {
    final FontLoader loader = FontLoader(family);
    for (final String p in paths) {
      loader.addFont(
        Future.value(ByteData.sublistView(File(p).readAsBytesSync())),
      );
    }
    await loader.load();
  }

  await load('Poppins', [
    for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold'])
      'assets/fonts/Poppins-$w.ttf',
  ]);
  await load('Roboto', [
    for (final w in ['regular', 'medium', 'bold'])
      '$sdkFonts/roboto-$w.ttf',
  ]);
  await load('MaterialIcons', ['$sdkFonts/materialicons-regular.otf']);
}
