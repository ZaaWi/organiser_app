import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:organiser_app/src/screens/tickets_screen.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatelessWidget {
  final Event event;
  // int eventID;
  CreateEvent({@required this.event});

  final String createEventMutation = r"""

mutation createEvent ($title: String!, $description: String!, $category: ID!, $city: ID!,
 $image: [ID], $organiser: ID!, $date: DateTime!, $limit: Int!, $location: String!) {
  createEvent 
  (
    input: {
      data: {
        title: $title,
        description: $description,
        category: $category,
        city: $city,
        image: $image,
        organiser: $organiser,
        date: $date,
        limit: $limit,
        location: $location,
      }
    }
  ) {
    event {
      title
      id
    }
  }
  
}


                  """;

  @override
  Widget build(BuildContext context) {
    Event createdEvent;
    final HttpLink httpLink = HttpLink(gqlUrl);
    String token = Provider.of<UserProvider>(context).user.token;

    final AuthLink auth =
        AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
    final Link link = auth.concat(httpLink);

    final ValueNotifier<GraphQLClient> createClient =
        ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: createClient,
      child: Mutation(
        options: MutationOptions(
          document: gql(createEventMutation),
          onCompleted: (dynamic resultData) {
            createdEvent = Event(
              id: int.parse(resultData['createEvent']['event']['id']),
              title: event.title,
              dateTime: event.dateTime,
              visitors: event.visitors,
              cityID: event.cityID,
              categoryID: event.categoryID,
              location: event.location,
              description: event.description,
              limit: event.limit,
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketScreen(
                  event: createdEvent,
                ),
              ),
            );
          }
        ),
        builder: (
          RunMutation runMutation,
          QueryResult result,
        ) {
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          }
          return AlertDialog(
            content: Text(
              'okay',
            ),
            actions: [
              FlatButton(
                child: Text('yes'),
                onPressed: () {
                  runMutation({
                    "title": event.title,
                    "description": event.description,
                    "city": event.cityID,
                    "category": event.categoryID,
                    "image": event.imageID,
                    "organiser": Provider.of<UserProvider>(context).user.id,
                    "date":
                        DateTimeFormat.format(DateTime.parse(event.dateTime)),
                    "limit": event.limit,
                    "location": event.location,
                  }
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
