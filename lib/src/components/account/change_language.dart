import 'package:flutter/material.dart';
import 'package:organiser_app/src/app.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';

class ChangeLanguage extends StatefulWidget {


  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  void changeLanguage(String langCode) {
    Locale _temp;
    switch (langCode) {
      case "en":
        _temp = Locale(langCode, "US");
        break;
      case "ar":
        _temp = Locale(langCode, "LY");
        break;

      default:
        _temp = Locale(langCode, "US");
    }
    MyApp.setLocale(context, _temp);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslate(context, "change_language")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    '🇱🇾',
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(getTranslate(context, "arabic")),
                  onTap: () {
                    changeLanguage('ar');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Text(
                    '🇦🇺',
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(getTranslate(context, "english")),
                  onTap: () {
                    changeLanguage('en');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.language_outlined),
      title: Text(
        getTranslate(context, "language"),
      ),
      subtitle: Text(
        getTranslate(context, "!"),
      ),
      onTap: () {
        _showMyDialog();
      },
    );
  }
}
