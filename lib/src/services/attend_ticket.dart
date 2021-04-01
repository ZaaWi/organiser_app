import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/api/graphql_operations/mutations.dart';
import 'package:organiser_app/src/api/graphql_operations/queries.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AttendTicket extends StatelessWidget {
  final Event event;
  final int bookingID;
  AttendTicket({this.event, this.bookingID});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(kGraphQLURL);
    String token = Provider.of<UserProvider>(context).user.token;

    final AuthLink auth =
        AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
    final Link link = auth.concat(httpLink);

    final ValueNotifier<GraphQLClient> attendanceClient =
        ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: attendanceClient,
      child: Query(
        options: QueryOptions(
          document: gql(getBookedTicketsQuery),
          variables: {"booking_id": bookingID, "event_id": event.id},
        ),
        builder: (QueryResult bookingResult,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (bookingResult.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (bookingResult.data == null) {
            return Center(
              child: Text('returned null'),
            );
          }
          //TODO: check if booking id exists
          List<BookedTicket> bookedTickets = [];
          for (var x in bookingResult.data['bookzs']) {
            BookedTicket bookedTicket = BookedTicket(
              bookingID: int.parse(x['id']),
              validity: x['validity'],
              bookedUserID: int.parse(x['booked_user']['id']),
            );
            bookedTickets.add(bookedTicket);
          }
          if (bookedTickets.isEmpty) {
            return Center(
              child: Text('ticket does not belong to this event'),
            );
          }
          return Query(
            options: QueryOptions(
                document: gql(getAttendedTicketsQuery),
                variables: {"booking_id": bookingID}),
            builder: (QueryResult attendanceResult,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (attendanceResult.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (attendanceResult.data == null) {
                return Center(
                  child: Text('returned null'),
                );
              }
              List<AttendedTicket> attendedTickets = [];
              for (var x in attendanceResult.data['attends']) {
                AttendedTicket attendedTicket = AttendedTicket(
                  attendID: int.parse(x['id']),
                );
                attendedTickets.add(attendedTicket);
              }
              if (attendedTickets.isNotEmpty) {
                return Center(
                  child: Text('this ticket attended'),
                );
              }
              if (bookedTickets[0].validity == 0) {
                return Center(
                  child: Text('this ticket is not valid'),
                );
              }
              return Mutation(
                options: MutationOptions(
                  document: gql(createAttendMutation),
                ),
                builder: (
                  RunMutation runAttendMutation,
                  QueryResult attendMutationResult,
                ) {
                  if (attendMutationResult.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  return Mutation(
                    options: MutationOptions(
                      document: gql(decreaseValidityMutation),
                    ),
                    builder: (
                      RunMutation runDecreaseMutation,
                      QueryResult decreaseResult,
                    ) {
                      if (decreaseResult.isLoading) {
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
                              runAttendMutation({
                                "booking_ID": bookingID,
                                "user_ID": bookedTickets[0].bookedUserID
                              });
                              runDecreaseMutation({
                                "booking_ID": bookingID,
                                "validity": bookedTickets[0].validity - 1
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
