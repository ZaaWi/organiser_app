
import 'package:flutter/material.dart';


class UploadProvider extends ChangeNotifier {

  String uploadedImageID;
  bool isCompleted;

  String get imageID {
    return uploadedImageID;
  }

  void setImageID(String id, bool state) {
    this.uploadedImageID = id;
    isCompleted = state;
  }


}
