import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalizations {
  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  MyLocalizations(this.locale);

  final Locale locale;
  final Map<String, String> _sentences = {};

  Future<bool> load() async {
    String data = await rootBundle.loadString('lang/${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    _result.forEach((String key, dynamic value) {
      _sentences[key] = value.toString();
    });
    return true;
  }

  String $(String key) => _sentences[key];
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) async {
    MyLocalizations localizations = new MyLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
