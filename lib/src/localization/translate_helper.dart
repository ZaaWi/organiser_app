
import 'package:flutter/material.dart';
import 'package:organiser_app/src/localization/demo_localization.dart';

String getTranslate(BuildContext context, String key) {
  if (DemoLocalization.of(context).getTranslatedValue(key) == null) {
    return 'unknown word';
  } else {
    return DemoLocalization.of(context).getTranslatedValue(key);
  }
}