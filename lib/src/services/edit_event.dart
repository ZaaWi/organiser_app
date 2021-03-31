import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditEvent extends StatelessWidget {

  final Event event;


  EditEvent({this.event});
  final String editEventMutation = r"""
  
  
   mutation EditEvent ($image_ID: [ID], $title: String!, $description: String!, $location: String!, 
$limit: Int! $date: DateTime! $category: ID!, $city: ID!, $event_ID: ID!) {
  updateEvent (
    input: {
      where: {
        id: $event_ID
      }
      data: {
        title: $title,
        description: $description,
        location: $location,
        limit: $limit,
        category: $category,
        city: $city,
        image: $image_ID,
        date: $date,
      }
    }
  )  {
    event {
      id
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

    final ValueNotifier<GraphQLClient> editClient =
    ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );


    return GraphQLProvider(
      client: editClient,
      child: Mutation(
        options: MutationOptions(
          document: gql(editEventMutation),
          onCompleted: (dynamic resultData) {
            print(resultData);
            Navigator.pop(context);
          }
        ),
        builder: (
        RunMutation runMutation,
            QueryResult result
        ) {
          print(result.exception.toString());


          return AlertDialog(
            content: Text(
              'edit ?',
            ),
            actions: [
              FlatButton(
                child: Text('yes'),
                onPressed: () {
                  runMutation({
                    "event_ID": event.id,
                    "title": event.title,
                    "description": event.description,
                    "city": event.cityID,
                    "category": event.categoryID,
                    "image_ID": event.imageID,
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
