import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/services/image_upload.dart';

class ImageForm extends StatefulWidget {
  final Event event;
  final String formType;

  ImageForm({this.event, this.formType});

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  File _image;
  final picker = ImagePicker();
  var mpFile;
  String imageID;
  bool isUploaded = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image selected');
      }
    });
    var byteData = _image.readAsBytesSync();
    var multipartFile = MultipartFile.fromBytes(
      'photo',
      byteData,
      filename: '${DateTime.now()}.jpg',
      contentType: MediaType("image", "jpg"),
    );
    mpFile = multipartFile;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.formType == 'EDIT') {
      return Column(
        children: [
          FlatButton(
            onPressed: getImage,
            child: Text('pick an image'),
          ),
          (_image == null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('$kApiKey${widget.event.img}'),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(_image),
                )),
          (_image == null
              ? Text('!!!')
              : ImageUpload(
                  multipartFile: mpFile,
                )),
        ],
      );
    } else {
      return Column(
        children: [
          FlatButton(
            onPressed: getImage,
            child: Text('pick an image'),
          ),
          (_image == null
              ? Text('no image')
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(_image),
                )),
          (_image == null
              ? Text('!!!')
              : ImageUpload(
                  multipartFile: mpFile,
                )),
        ],
      );
    }
  }
}
