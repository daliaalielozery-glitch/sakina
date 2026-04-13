import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sakina/sakina_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp( EasyLocalization(
       supportedLocales: [Locale('en'), Locale('ar')],
      path: 'aassets/dalia_assets/translations',
      fallbackLocale: Locale('en'),
    child: SakinaApp()));
}
