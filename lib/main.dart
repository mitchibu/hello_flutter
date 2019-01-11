import 'package:flutter/material.dart';
import 'package:flutter\_localizations/flutter\_localizations.dart';

import 'localizations.dart';
import 'ui/home/main.dart';

void main() => runApp(MyApplication());

final ThemeData themeData = ThemeData(
  primarySwatch: Colors.blue,
);

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => MyLocalizations.of(context).$('app_name'),
      theme: themeData,
      supportedLocales: [
        const Locale('en', 'US')
      ],
      localizationsDelegates: [
        const MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,  
        GlobalWidgetsLocalizations.delegate  
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for(var supportedLocale in supportedLocales) {
          if(supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: HomeWidget(),
    );
  }
}
