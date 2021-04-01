import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/api/graphql_operations/mutations.dart';
import 'package:organiser_app/src/providers/upload_provider.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';


class ImageUpload extends StatefulWidget {
  final multipartFile;


  ImageUpload({@required this.multipartFile});

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  String imageID;



  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(kGraphQLURL);
    String token = Provider.of<UserProvider>(context).user.token;

    final AuthLink auth =
        AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
    final Link link = auth.concat(httpLink);

    final ValueNotifier<GraphQLClient> uploadClient =
        ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: uploadClient,
      child: Mutation(
        options: MutationOptions(document: gql(uploadImageMutation)),
        builder: (
          RunMutation runMutation,
          QueryResult result,
        ) {
          if (result.data != null) {
            String id = result.data['upload']['id'];
            Provider.of<UploadProvider>(context).setImageID(id, true);
          }
          return Container(
            child: RaisedButton(
              color: Colors.blueGrey,
              onPressed: () {
                runMutation(<String, dynamic>{
                  //TODO: upload mutation
                  'file': widget.multipartFile
                });
              },
              child: Text('upload'),
            ),
          );
        },
      ),
    );
  }
}
