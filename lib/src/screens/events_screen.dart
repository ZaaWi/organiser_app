import 'package:flutter/material.dart';
import 'package:organiser_app/src/providers/upload_provider.dart';
import 'package:organiser_app/src/screens/event_form_screen.dart';
import 'package:organiser_app/src/services/events_list.dart';
import 'package:provider/provider.dart';


class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 248, 253, 1),
      appBar: AppBar(
        title: Text(
          'organiser',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.blue[200],
        elevation: 0,
        brightness: Brightness.light,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        actions: <Widget>[
          //TODO: user avatar
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: Container(
          //     width: 35,
          //     height: 35,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       image: DecorationImage(
          //         //TODO: fix this image.
          //         image: AssetImage('assets/images/four.jpg'),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //     child: Transform.translate(
          //       offset: Offset(15, -15),
          //       child: Container(
          //         margin: EdgeInsets.all(10),
          //         decoration: BoxDecoration(
          //             border: Border.all(width: 3, color: Colors.white),
          //             shape: BoxShape.circle,
          //             color: Colors.yellow[800]),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              EventsList(),
              // ItemsCardList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                builder: (context) => UploadProvider(),
                child: EventFormScreen(
                  formType: 'ADD',
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
