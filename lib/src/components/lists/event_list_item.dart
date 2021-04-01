import 'package:flutter/material.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/upload_provider.dart';
import 'package:organiser_app/src/screens/attendance_details_screen.dart';
import 'package:organiser_app/src/screens/event_form_screen.dart';
import 'package:organiser_app/src/screens/ticket_form_screen.dart';
import 'package:provider/provider.dart';

Widget listItem({BuildContext context, Event event}) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage('$kApiKey${event.img}'),
      ),
      title: Text(event.title),
      subtitle: Text(
          '${event.getDate(event.dateTime)} ${event.getTime(event.dateTime)}'),
      trailing: Icon(Icons.more_vert),
      onTap: () {
        //TODO: navigate to event details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              builder: (context) => UploadProvider(),
              child: EventFormScreen(
                event: event,
                formType: 'EDIT',
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget eventsListItems({BuildContext context, Event event}) {
  return Card(
    child: ListTile(
      title: Text('${event.title}'),
      trailing: Text('${event.visitors} - ${event.limit}'),
      onTap: () {
        //TODO: navigate to attendance
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceDetailsScreen(event: event,),
          ),
        );
      },
    ),
  );
}


Widget ticketsListItems ({BuildContext context, Ticket ticket}) {
  return Card(
    child: ListTile(
      title: Text('${ticket.ticketName}'),
      trailing: Text('${ticket.quantity}'),
      onTap: () {
        //TODO: navigate to ticket edit form
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(context) => TicketFormScreen(
              formType: 'EDIT',
              ticket: ticket,
            ),
          ),
        );
      },
    ),
  );
}