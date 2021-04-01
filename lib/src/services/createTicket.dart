import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/api/graphql_operations/mutations.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:organiser_app/src/screens/app_screen.dart';
import 'package:provider/provider.dart';

class CreateTicket extends StatelessWidget {
  //TODO: change to final
   final Ticket ticket;

  CreateTicket({this.ticket,});

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
      child: Mutation(
        options: MutationOptions(
          document: gql(createTicketMutation),
          onCompleted: (dynamic resultData) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppScreen(),
              ),
            );
          }
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
                    "event_ID": ticket.event.id,
                  });

                },
              ),
            ],
          );

        },
      ),
    );
  }
}
