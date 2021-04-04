
import 'package:flutter/material.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/components/account/profile_header.dart';
import 'package:organiser_app/src/components/account/user_info.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                avatar:NetworkImage(
                    '$kApiKey${Provider.of<UserProvider>(context).user.avatar}'),
                coverImage: NetworkImage(
                    '$kApiKey${Provider.of<UserProvider>(context).user.avatar}'),
                title: Provider.of<UserProvider>(context).user.userName,
                subtitle: getTranslate(context, "organizer"),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              UserInfo(),
            ],
          ),
        ));
  }
}

