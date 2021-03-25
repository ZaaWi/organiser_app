import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/api/api_config.dart';
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

    );
  }
}
