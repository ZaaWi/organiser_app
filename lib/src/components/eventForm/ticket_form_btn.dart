
import 'package:flutter/material.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/screens/tickets_screen.dart';

class TicketFormBtn extends StatelessWidget {
  final Event event;


  TicketFormBtn({this.event});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
        height: 58,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 5),
          child: Text(getTranslate(context, "Add_tickets")),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(context) => TicketScreen(event: event,),
          ),
        );
      },
    );
  }
}