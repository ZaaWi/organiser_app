import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organiser_app/src/services/events_categories_cities.dart';

class EventFormScreen extends StatefulWidget {
  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  String _chosenCategoryName = '';
  String _chosenCityName = '';
  int _chosenCityID;
  int _chosenCategoryID;

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
              Column(
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
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('description'),
                  TextFormField (
                    controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter description';
                      }
                      return null;
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
                    onChanged: (val) => print(val),
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

                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('category: $_chosenCategoryName');
          print('city: $_chosenCityName');
          print('city id: $_chosenCityID');
          print('category id: $_chosenCategoryID');
          if (_formKey.currentState.validate()) {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    nameController.text,
                  ),
                );
              },
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
