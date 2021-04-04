import 'package:flutter/material.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/screens/ticket_form_screen.dart';
import 'package:organiser_app/src/services/tickets_list.dart';

class TicketScreen extends StatefulWidget {
  final Event event;

  TicketScreen({this.event});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslate(context, "Tickets")),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO: tickets
            TicketsList(
              event: widget.event,
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:(context) => TicketFormScreen(
                event: widget.event,
                formType: 'ADD',
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
