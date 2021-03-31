import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditTicket extends StatelessWidget {
  final Ticket ticket;


  EditTicket({this.ticket});

  final String editTicketMutation = r"""
  mutation editTicket ($ticket_ID: ID!, $name: String!, $quantity: Int!) {
  updateTickt 
  (
    input: {
      where: {
        id: $ticket_ID
      }
      data: {
        name: $name,
        quantity: $quantity
      }
    }
  )
  {
    tickt {
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
    final ValueNotifier<GraphQLClient> editClient =
        ValueNotifier<GraphQLClient>(
          GraphQLClient(
            link: link,
            cache: GraphQLCache(),
          )
        );

    return GraphQLProvider(
      client: editClient,
      child: Mutation(
        options: MutationOptions(
          document: gql(editTicketMutation),
          onCompleted: (dynamic resultData) {
            //TODO: onComplete
            Navigator.pop(context);
          }
        ),
        builder: (
        RunMutation runMutation, QueryResult result
        ) {
          return AlertDialog(
            content: Text(
              'edit ?',
            ),
            actions: [
              FlatButton(
                child: Text('yes'),
                onPressed: () {
                  runMutation({
                    "ticket_ID": ticket.id,
                    "name": ticket.ticketName,
                    "quantity": ticket.quantity,
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
