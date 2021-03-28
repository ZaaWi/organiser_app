import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/providers/upload_provider.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';


class ImageUpload extends StatefulWidget {
  var multipartFile;


  ImageUpload({@required this.multipartFile});

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  String imageID;

  final String uploadImageMutation = r"""
  
  
mutation uploadImage ($file: Upload!) {
  upload
  (
    file: $file
  )
  {
    name
    id
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
          print(result.exception.toString());

          if (result.data != null) {
            print('upload completed');
            print(result.data);
            print(result.data['upload']['id']);
            String id = result.data['upload']['id'];
            Provider.of<UploadProvider>(context).setImageID(id, true);
            print(Provider.of<UploadProvider>(context).imageID);
            print('in upload image');

          }

          return Container(
            child: RaisedButton(
              color: Colors.blueGrey,
              onPressed: () {
                print('before mutation');
                runMutation(<String, dynamic>{
                  //TODO: upload mutation
                  'file': widget.multipartFile
                });
                print('after mutation');
              },
              child: Text('upload'),
            ),
          );
        },
      ),
    );
  }
}
