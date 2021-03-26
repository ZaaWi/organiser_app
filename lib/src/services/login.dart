
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:organiser_app/src/screens/app_screen.dart';
import 'package:provider/provider.dart';





class Login extends StatelessWidget {

  final String loginQuery = r"""
                  mutation {
  login(input: { identifier: "zawi", password: "Zawi123" }) {
    jwt
    user {
      username
      id
      email
      role {
        id
      }
      
      
      
      
    }
  }
}


                  """;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Query(
        options: QueryOptions(
          document: gql(loginQuery),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}
        ) {
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

          print('all data');
          print(result.data);
          print('jwt');
          print(result.data['login']['jwt']);
          print(result.data['login']['user']['username']);
          print(result.data['login']['user']['id']);
          //TODO: check the user rule :
          Provider.of<UserProvider>(context).setUserData(
            token: result.data['login']['jwt'],
            id: int.parse(result.data['login']['user']['id']),
            userName: result.data['login']['user']['username'],
          );


          return AppScreen();
        },
      ),
    );
  }
}
