
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/components/lists/event_list_item.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TicketsList extends StatefulWidget {

  final Event event;


  TicketsList({this.event});

  @override
  _TicketsListState createState() => _TicketsListState();
}

class _TicketsListState extends State<TicketsList> {
  final String getEventTicketsQuery = r"""
  query getEventTickets ($event_ID: ID!) {
  tickts
  (
    where: {
      event: {
        id: $event_ID
      }
    }
  )
  {
    id
    name
    quantity
    event{
      id
      title
    }
  }
}
""";

  Widget getTicketItems (List<Ticket> tickets) {
    List<Widget> list = List<Widget>();
    for (Ticket t in tickets) {
      list.add(
          ticketsListItems(
            context: context,
            ticket: t,
          ),
      );
    }

    return Column(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {

    final HttpLink httpLink = HttpLink(gqlUrl);
    String token = Provider.of<UserProvider>(context).user.token;

    final AuthLink auth =
    AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
    final Link link = auth.concat(httpLink);

    final ValueNotifier<GraphQLClient> ticketsClient =
    ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: ticketsClient,
      child: Query(
        options: QueryOptions(
          document: gql(getEventTicketsQuery),
          variables: {
            "event_ID": widget.event.id
          }
        ),
        builder: (
        QueryResult ticketsResult,
            {
              VoidCallback refetch, FetchMore fetchMore
            }
        ) {
          if(ticketsResult.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (ticketsResult.data == null) {
            return Center(
              child: Text(
                'no tickets'
              ),
            );
          }
          List<Ticket> ticketList = [];
          for (var t in ticketsResult.data['tickts']) {
            Ticket ticket = Ticket(
              id: int.parse(t['id']),
              ticketName: t['name'],
              quantity: t['quantity'],
              event: Event(
                id: int.parse(t['event']['id']),
                title: t['event']['title'],
              ),
            );
            ticketList.add(ticket);
          }

          return Column(
            children: [
              getTicketItems(ticketList),
            ],
          );
        },
      ),
    );
  }
}
