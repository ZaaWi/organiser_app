import 'package:flutter/material.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';

class DashboardEventsCard extends StatelessWidget {
  const DashboardEventsCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              leading: Container(
                alignment: Alignment.bottomCenter,
                width: 45.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 20,
                      width: 8.0,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 4.0),
                    Container(
                      height: 25,
                      width: 8.0,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 4.0),
                    Container(
                      height: 40,
                      width: 8.0,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 4.0),
                    Container(
                      height: 30,
                      width: 8.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              title: Text(getTranslate(context, "today")),
              subtitle: Text('2 events'),
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: ListTile(
              leading: Container(
                alignment: Alignment.bottomCenter,
                width: 45.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 20,
                      width: 8.0,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 4.0),
                    Container(
                      height: 25,
                      width: 8.0,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 4.0),
                    Container(
                      height: 40,
                      width: 8.0,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4.0),
                    Container(
                      height: 30,
                      width: 8.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              title: Text('Finished'),
              subtitle: Text('7 events'),
            ),
          ),
        ],
      ),
    );
  }
}