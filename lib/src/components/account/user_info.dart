import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/account/change_language.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,),
            // alignment: Alignment.topCenter,
            child: Text(
              getTranslate(context, "user_information"),
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text(
                              getTranslate(context, "email"),
                            ),
                            subtitle: Text(Provider.of<UserProvider>(context).user.email),
                          ),
                          ListTile(
                            leading: Icon(Icons.https_outlined),
                            title: Text(
                              getTranslate(context, "password"),
                            ),
                            subtitle: Text("*************"),
                          ),
                          ChangeLanguage(),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
