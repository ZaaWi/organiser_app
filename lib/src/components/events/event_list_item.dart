

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/event_model.dart';

Widget ListItem ({BuildContext context, Event event}) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage('$apiUrl${event.img}'),
      ),
      title: Text(event.title),
      subtitle: Text('${event.getDate(event.dateTime)} ${event.getTime(event.dateTime)}'),
      trailing: Icon(Icons.more_vert),
      onTap: () {
        //TODO: navigate to event details
      },
    ),
  );
}