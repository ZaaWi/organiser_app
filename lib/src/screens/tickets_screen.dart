import 'package:flutter/material.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/screens/ticket_form_screen.dart';

class TicketScreen extends StatefulWidget {
  Event event;

  TicketScreen({this.event});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ticket'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO: tickets
            (widget.event.tickets == null ?
                Center(
                  child: Text('null'),
                )
                :
                Center(
                  child: Text('not null'),
                ))

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:(context) => TicketFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
