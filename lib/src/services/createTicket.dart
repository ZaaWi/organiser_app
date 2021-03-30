import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:organiser_app/src/screens/app_screen.dart';
import 'package:provider/provider.dart';

class CreateTicket extends StatelessWidget {
  //TODO: change to final
   final Ticket ticket;

  CreateTicket({this.ticket});

  final String createTicketMutation = r"""

mutation createTicket ($name: String!, $event_ID: ID!, $quantity: Int!) {
  createTickt 
  (
    input: {
      data: {
        name: $name,
        event: $event_ID,
        quantity: $quantity
  
      }
    }
  ) {
    tickt {
      name
      id
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
          document: gql(createTicketMutation),
        ),
        builder: (
            RunMutation runMutation,
            QueryResult result,
        ) {
          if(result.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          }
          if(result.data != null) {
            print('-------------------------------------');
            print(result.data);
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
                    "name": ticket.ticketName,
                    "quantity": ticket.quantity,
                    "event_ID": ticket.event.id.toString(),
                  });
                  print(result.exception.toString());
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppScreen(),
                    ),
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
