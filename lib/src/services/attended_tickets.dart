import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/api/graphql_operations/queries.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AttendedTickets extends StatelessWidget {

  final Event event;
  AttendedTickets({this.event});

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
          document: gql(attendedTicketsQuery),
          variables: {
            "event_id": event.id,
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

          List<AttendedTicket> attendedBookedTickets = [];


          for(var attend in result.data['attends']) {
            //create a bookedTicket instance to add it in the booked tickets list
            AttendedTicket ticket = AttendedTicket(
              attendID: int.parse(attend['id']),
              bookedTicket: BookedTicket(
                bookingID: int.parse(attend['booking']['id']),
                validity: attend['booking']['validity'],
                bookedUserID: int.parse(attend['attend_user']['id']),
                id: int.parse(attend['booking']['ticket']['id']),
              ),

            );
            //add the ticket to the booked tickets list
            attendedBookedTickets.add(ticket);
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
                            Text('number of attended tickets'),
                            Text('${attendedBookedTickets.length}',
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
