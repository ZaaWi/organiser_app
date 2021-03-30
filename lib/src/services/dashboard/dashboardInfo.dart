import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/components/dashboard/dashboard_events_info.dart';
import 'package:organiser_app/src/components/dashboard/dashboard_tickets_info.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DashboardInfo extends StatelessWidget {
  final String countEventsQuery = r"""
  
query countEvents ($user_ID: ID!) {
  eventsConnection
  (
    where: {
      organiser: {
        id: $user_ID
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}

                  """;
  final String countLikesQuery = r"""
  
query getLikes ($user_ID: ID!) {
  usersConnection 
  (
    where: {
      wishlist: {
        organiser: {
          id: $user_ID
        }
      }
    }
  )
  {
    aggregate {
      count 
    }
  }
}

                  """;
  final String countTicketsQuery = r"""
  
  
query ticketCount ($user_ID: ID!) {
  ticktsConnection 
  (
    where: {
      event: {
        organiser: {
          id: $user_ID
        }
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}


                  """;
  final String countBookedTicketsQuery = r"""
  
query bookingCount ($user_ID: ID!) {
  bookzsConnection 
  (
    where: {
      event: {
        organiser: {
          id: $user_ID
        }
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}
                  """;
  final String countAttendanceQuery = r"""
query attendanceCount ($user_ID: ID!) {
  attendsConnection 
  (
    where: {
      booking: {
        event: {
          organiser: {
            id: $user_ID
          }
        }
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}

                  """;

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(gqlUrl);
    String token = Provider.of<UserProvider>(context).user.token;

    final AuthLink auth =
        AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
    final Link link = auth.concat(httpLink);

    final ValueNotifier<GraphQLClient> dashboardClient =
        ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: dashboardClient,
      child: Query(
        options: QueryOptions(
            document: gql(countEventsQuery),
            variables: {"user_ID": Provider.of<UserProvider>(context).user.id}),
        builder: (QueryResult eventCountResult,
            {VoidCallback refetch, FetchMore fetchMore}) {
          //TODO: events count
          if (eventCountResult.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Query(
            options: QueryOptions(document: gql(countLikesQuery), variables: {
              "user_ID": Provider.of<UserProvider>(context).user.id
            }),
            builder: (QueryResult likesResult,
                {VoidCallback refetch, FetchMore fetchMore}) {
              //TODO: count likes
              if (likesResult.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Query(
                options: QueryOptions(
                    document: gql(countTicketsQuery),
                    variables: {
                      "user_ID": Provider.of<UserProvider>(context).user.id
                    }),
                builder: (QueryResult ticketsResult,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  //TODO: count tickets
                  if (ticketsResult.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Query(
                      options: QueryOptions(
                        document: gql(countBookedTicketsQuery),
                        variables: {
                          "user_ID": Provider.of<UserProvider>(context).user.id
                        },
                      ),
                      builder: (QueryResult bookingResult,
                          {VoidCallback refetch, FetchMore fetchMore}) {
                        //TODO: count booked tickets
                        if (bookingResult.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Query(
                          options: QueryOptions(
                            document: gql(countAttendanceQuery),
                            variables: {
                              "user_ID":
                                  Provider.of<UserProvider>(context).user.id
                            },
                          ),
                          builder: (QueryResult attendanceResult,
                              {VoidCallback refetch, FetchMore fetchMore}) {
                            //TODO: count attendance
                            if (attendanceResult.isLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Column(
                              children: [
                                DashboardEventsInfo(
                                  numberOfEvents: eventCountResult.data['eventsConnection']['aggregate']['count'],
                                  likes: likesResult.data['usersConnection']['aggregate']['count'],
                                ),
                                const SizedBox(height: 16.0),
                                DashboardTicketsInfo(
                                  tickets: ticketsResult.data['ticktsConnection']['aggregate']['count'],
                                  booked: bookingResult.data['bookzsConnection']['aggregate']['count'],
                                  attended: attendanceResult.data['attendsConnection']['aggregate']['count'],
                                ),
                              ],
                            );
                          },
                        );
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}
