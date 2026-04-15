import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sakina/sakina_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp( EasyLocalization(
       supportedLocales: [Locale('en'), Locale('ar')],
<<<<<<< HEAD
      path: 'assets/dalia_assets/translations',
      fallbackLocale: Locale('en'),
        startLocale: Locale('en'), 

=======
      path: 'aassets/dalia_assets/translations',
      fallbackLocale: Locale('en'),
>>>>>>> 8f9cdcd59d37c5815a6a267e454ff4baf7e7d6c4
    child: SakinaApp()));
}
