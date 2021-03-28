import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatelessWidget {

  Event event;

  CreateEvent(this.event);



  final String createEventMutation = r"""

mutation createEvent ($title: String!, $description: String!, $category: ID!, $city: ID!,
 $image: [ID], $organiser: ID!) {
  createEvent 
  (
    input: {
      data: {
        title: $title,
        description: $description,
        category: $category,
        city: $city,
        image: $image,
        organiser: $organiser
      }
    }
  ) {
    event {
      title
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

    final ValueNotifier<GraphQLClient> createClient = ValueNotifier<GraphQLClient>(
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
        ),
        builder: (
            RunMutation runMutation,
            QueryResult result,
        ) {
          print(result.data);
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
                    "organiser": Provider.of<UserProvider>(context).user.id
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
