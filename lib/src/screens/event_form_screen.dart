import 'package:date_time_format/date_time_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/eventForm/form_image.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/providers/upload_provider.dart';
import 'package:organiser_app/src/services/create_event.dart';
import 'package:organiser_app/src/services/events_categories_cities.dart';
import 'package:provider/provider.dart';

class EventFormScreen extends StatefulWidget {
  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  String _chosenCategoryName = '';
  String _chosenCityName = '';
  int _chosenCityID;
  int _chosenCategoryID;
  String imageID;
  bool isImageUploaded = false;
  Widget createEvent;
  String _title;
  String _description;
  int _category;
  int _city;
  int _image;
  Event event;
  String _dateTime;


  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              (createEvent == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text('title'),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please enter title';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _title = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('description'),
                        TextFormField(
                          controller: descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please enter description';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _description = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('event date'),
                        DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          // initialValue: DateTime.now().toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          onChanged: (val) {
                            _dateTime = val;
                            print(DateTimeFormat.format(DateTime.parse(_dateTime)));

                          },
                          validator: (val) {
                            print(val);
                            if (val == null || val.isEmpty) {
                              return 'please pick a date';
                            }
                            return null;
                          },
                          onSaved: (val) => print(val),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('Categories'),
                        EventsCategoriesAndCities(
                          cityCallback: (
                            id,
                            name,
                          ) {
                            _chosenCityName = name;
                            _chosenCityID = id;
                          },
                          categoryCallback: (
                            id,
                            name,
                          ) {
                            _chosenCategoryID = id;
                            _chosenCategoryName = name;
                          },
                        ),
                        //TODO: image upload
                        ImageForm(),
                      ],
                    )
                  : createEvent),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print('category: $_chosenCategoryName');
          // print('city: $_chosenCityName');
          // print('city id: $_chosenCityID');
          // print('category id: $_chosenCategoryID');
          // print('from root id: ${Provider.of<UploadProvider>(context).imageID}');
          // print('in root');
          // print(_formKey.currentState.validate());
          // if form is valid
          if (_formKey.currentState.validate() &&
              Provider.of<UploadProvider>(context).imageID != null) {
            setState(() {
              createEvent = CreateEvent(
                Event(
                  title: _title,
                  description: _description,
                  categoryID: _chosenCategoryID,
                  city: _chosenCityName,
                  cityID: _chosenCityID,
                  imageID: Provider.of<UploadProvider>(context).imageID,
                  dateTime: _dateTime,
                ),
              );
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
