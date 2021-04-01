
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/graphql_operations/queries.dart';
import 'package:organiser_app/src/components/lists/event_list_item.dart';
import 'package:organiser_app/src/models/city_model.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';



class EventsList extends StatefulWidget {



  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {

  Widget getEventItems (List<Event> evs) {
    List<Widget> list = List<Widget>();
    for (Event e in evs) {
      list.add(
          listItem(
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
        document: gql(getEventsQueryCopy),
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
            id: int.parse(e['id']),
            title: e['title'],
            description: e['description'],
            dateTime: e['date'],
            img: e['image'][0]['formats'],
            imageID: e['image'][0]['id'],
            tickets: tickets,
            visitors: e['visitors'],
            limit: e['limit'],
            location: e['location'],
            city: e['city']['name'],
            cityID: int.parse(e['city']['id']),
            cityObject: City(
              name: e['city']['name'],
              id: int.parse(e['city']['id']),
            ),
            categoryName: e['category']['name'],
            categoryID: int.parse(e['category']['id']),
          );
          eventList.add(event);
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
