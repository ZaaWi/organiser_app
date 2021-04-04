import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/api/graphql_operations/mutations.dart';
import 'package:organiser_app/src/api/graphql_operations/queries.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:organiser_app/src/screens/app_screen.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
        options: QueryOptions(
          document: gql(loginMutation),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
            );
          }
          if (result.data == null) {
            return Center(
              child: Text(
                'null',
              ),
            );
          }
          Provider.of<UserProvider>(context).setUserData(
            token: result.data['login']['jwt'],
            id: int.parse(result.data['login']['user']['id']),
            userName: result.data['login']['user']['username'],
            email: result.data['login']['user']['email'],
          );
          //TODO: check the user rule :

          final HttpLink httpLink = HttpLink(kGraphQLURL);
          String token = Provider.of<UserProvider>(context).user.token;

          final AuthLink auth =
          AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
          final Link link = auth.concat(httpLink);

          final ValueNotifier<GraphQLClient> userClient = ValueNotifier<GraphQLClient>(
            GraphQLClient(
              link: link,
              cache: GraphQLCache(),
            ),
          );

          return GraphQLProvider(
            client: userClient,
            child: Query(
                options: QueryOptions(
                  document: gql(getUserImageQuery),
                  variables: {
                    "id": int.parse(result.data['login']['user']['id'])
                  }
                ),
                builder: (QueryResult imageResult,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (imageResult.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(imageResult.data == null) {
                    return Center(
                      child: Text(
                        'returnned null'
                      ),
                    );
                  }
                  Provider.of<UserProvider>(context).setAvatar(imageResult.data['users'][0]['avatar']['url']);



                  return AppScreen();
                }),
          );
        },
      ),
    );
  }
}
