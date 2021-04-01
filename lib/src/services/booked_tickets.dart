import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/api/graphql_operations/queries.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BookedTickets extends StatelessWidget {

  final Event event;
  BookedTickets({this.event});

  @override
  Widget build(BuildContext context) {

    final HttpLink httpLink = HttpLink(kGraphQLURL);
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
      child: Query(
        options: QueryOptions(
          document: gql(getBookedTicketsQueryCopy),
          variables: {
            "event_id": event.id
          },
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.data == null) {
            return Center(
              child: Text(
                'returned null'
              ),
            );
          }


          // list for the booked tickets
          List<BookedTicket> bookedTickets = [];

          for(var bt in result.data['bookzs']) {
            //create a bookedTicket instance to add it in the booked tickets list
            BookedTicket ticket = BookedTicket(
              bookingID: int.parse(bt['id']),
              event: Event(
                title: bt['event']['title'],
                id: int.parse(bt['event']['id']),
              ),
              id: int.parse(bt['ticket']['id']),
              ticketName: bt['ticket']['name'],
              quantity: bt['ticket']['quantity'],
              validity: bt['validity'],
            );
            bookedTickets.add(ticket);

          }
          return Center(
            child: Card(
              child: Expanded(
                child: Container(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('number of booked tickets'),
                          Text('${bookedTickets.length}',
                            style: TextStyle(
                              fontSize: 28
                            ),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ),
          );
        },
      ),
    );
  }
}
