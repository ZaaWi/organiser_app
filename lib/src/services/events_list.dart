
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/components/events/event_list_item.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';



class EventsList extends StatefulWidget {



  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
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
    title
    description
    date
    visitors
    category {
      id
      name
    }
    image {
      formats:url
    }
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
          ListItem(
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
            description: e['description'],
            dateTime: e['date'],
            img: e['image'][0]['formats'],
            tickets: tickets,
            visitors: e['visitors'],
            limit: e['limit'],
            location: e['location'],
            city: e['city']['name'],
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
