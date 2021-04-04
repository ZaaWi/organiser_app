import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/eventForm/form_image.dart';
import 'package:organiser_app/src/components/eventForm/ticket_form_btn.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/providers/upload_provider.dart';
import 'package:organiser_app/src/services/create_event.dart';
import 'package:organiser_app/src/services/edit_event.dart';
import 'package:organiser_app/src/services/events_categories_cities.dart';
import 'package:provider/provider.dart';

class EventFormScreen extends StatefulWidget {
  final Event event;
  final String formType;

  EventFormScreen({this.event, this.formType});

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
  Widget eventService;
  String _title;
  String _description;
  int _category;
  int _city;
  int _image;
  String _dateTime;
  String _location;
  int _limit;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final limitController = TextEditingController();

  //TODO: refactor util

  bool isNumeric(String stringNumber) {
    if (stringNumber == null) {
      return false;
    }
    return double.tryParse(stringNumber) != null;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslate(context, "event_${widget.formType}_form")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              (eventService == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        ImageForm(
                          formType: widget.formType,
                          event: widget.event,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(getTranslate(context, "title")),
                        TextFormField(
                          initialValue: widget.formType == 'EDIT'
                              ? widget.event.title
                              : null,
                          // controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return getTranslate(context, "please_enter_title");
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
                        Text(getTranslate(context, "description"),),
                        TextFormField(
                          initialValue: widget.formType == 'EDIT'
                              ? widget.event.description
                              : null,
                          // controller: descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return getTranslate(context, "please_enter_description");
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
                        Text(getTranslate(context, "location")),
                        TextFormField(
                          initialValue: widget.formType == 'EDIT'
                              ? widget.event.location
                              : null,
                          // controller: descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return getTranslate(context, "please_enter_location");
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _location = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(getTranslate(context, "limit")),
                        TextFormField(
                          initialValue: widget.formType == 'EDIT'
                              ? widget.event.limit.toString()
                              : null,
                          keyboardType: TextInputType.number,
                          // controller: descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (isNumeric(value)) {
                                return getTranslate(context, "value_has_to_be_number");
                              }
                              return getTranslate(context, "please_enter_the_limit");
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // _description = value;
                            _limit = int.parse(value);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(getTranslate(context, "event_date")),
                        DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          initialValue: widget.formType == 'EDIT'
                              ? widget.event.dateTime
                              : null,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: getTranslate(context, "Date"),
                          onChanged: (val) {
                            _dateTime = val;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return getTranslate(context, "please_pick_a_date");
                            }
                            return null;
                          },
                          onSaved: (val) => print(val),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(getTranslate(context, "Categories")),
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
                          event: widget.event,
                          formType: widget.formType,
                        ),
                        widget.formType == 'EDIT' ? Text(getTranslate(context, "Tickets")) : Container(),
                        SizedBox(
                          height: 15,
                        ),
                        widget.formType == 'EDIT' ? TicketFormBtn(
                          event: widget.event
                        ) :
                        Container(),
                        SizedBox(
                          height: 80,
                        ),
                        //TODO: image upload
                      ],
                    )
                  : eventService),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if form is valid
          if (_formKey.currentState.validate()) {
            setState(() {
              if (Provider.of<UploadProvider>(context).imageID != null &&
                  widget.formType == 'ADD') {
                eventService = CreateEvent(
                  event: Event(
                    title: _title,
                    description: _description,
                    categoryID: _chosenCategoryID,
                    city: _chosenCityName,
                    cityID: _chosenCityID,
                    imageID: Provider.of<UploadProvider>(context).imageID,
                    dateTime: _dateTime,
                    location: _location,
                    limit: _limit,
                  ),
                );
              } else {
                eventService = EditEvent(
                  event: Event(
                    id: widget.event.id,
                    title: _title == null ? widget.event.title : _title,
                    description: _description == null
                        ? widget.event.description
                        : _description,
                    categoryID: _chosenCategoryID == null
                        ? widget.event.categoryID
                        : _chosenCategoryID,
                    city: _chosenCityName == null
                        ? widget.event.city
                        : _chosenCityName,
                    cityID: _chosenCityID == null
                        ? widget.event.cityID
                        : _chosenCityID,
                    imageID:
                        Provider.of<UploadProvider>(context).imageID == null
                            ? widget.event.imageID
                            : Provider.of<UploadProvider>(context).imageID,
                    dateTime:
                        _dateTime == null ? widget.event.dateTime : _dateTime,
                    location:
                        _location == null ? widget.event.location : _location,
                    limit: _limit == null ? widget.event.limit : _limit,
                  ),
                );
              }
            });
          }
        },
        child: widget.formType == 'EDIT'
            ? Icon(Icons.playlist_add_check_outlined)
            : Icon(Icons.add),
      ),
    );
  }
}


