

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/components/lists/event_list_item.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AttendanceEventList extends StatefulWidget {
  @override
  _AttendanceEventListState createState() => _AttendanceEventListState();
}

class _AttendanceEventListState extends State<AttendanceEventList> {

  final String getEventsQuery = r"""
  
  
query getMyEvents ($organiser_id: ID!) {
  events 
  (
    where: {
      organiser: {
        id: $organiser_id
      }
    }
  )
  {
    id
    visitors
    title
    limit
    location
    city {
      name
    }
    tickts {
      id
      quantity
      name
    }
  }
}



                  """;

  Widget getEventItems (List<Event> evs) {
    List<Widget> list = List<Widget>();
    for (Event e in evs) {
      list.add(
        eventsListItems(
          context: context,
          event: e,
        ),
      );
    }
    return Column(
      children: list,
    );
  }
  @override
  Widget build(BuildContext context) {
    print('user id : ${Provider.of<UserProvider>(context).user.id}');
    return Query(
      options: QueryOptions(
        document: gql(getEventsQuery),
        variables: {
          'organiser_id': Provider.of<UserProvider>(context).user.id,
        },
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
        if (result.data == null) {
          return Center(
            child: Text('null'),
          );
        }
        List<Event> eventList = [];
        for (var e in result.data['events']) {
          List<Ticket> tickets = [];
          for (var t in e['tickts']) {
            tickets.add(
                Ticket(
                  ticketName: t['name'],
                  id: int.parse(t['id']),
                  quantity: t['quantity'],
                )
            );
          }
          Event event = Event(
            title: e['title'],
            tickets: tickets,
            visitors: e['visitors'],
            limit: e['limit'],
            location: e['location'],
            city: e['city']['name'],
            id: int.parse(e['id']),
          );
          eventList.add(event);
          print(e['date']);
        }
        return Column(
          children: [
            getEventItems(eventList),
          ],
        );

      },
    );
  }
}
