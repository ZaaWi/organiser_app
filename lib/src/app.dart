import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:organiser_app/src/screens/login_screen.dart';
import 'package:provider/provider.dart';


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final HttpLink httpLink = HttpLink(gqlUrl);
    final ValueNotifier<GraphQLClient> loginClient = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

    return ChangeNotifierProvider(
      builder: (context) => UserProvider(),
      child: GraphQLProvider(
        client: loginClient,
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => LoginScreen(),
          },
        ),
      ),
    );
  }
}
