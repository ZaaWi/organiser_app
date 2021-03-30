import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/dashboard/dashboard_card.dart';


class DashboardEventsInfo extends StatelessWidget {

  final int numberOfEvents;
  final int likes;


  DashboardEventsInfo({this.numberOfEvents, this.likes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: dashboardCard(
              color: Colors.blue,
              icon: Icons.event,
              title: 'Number of Events',
              data: numberOfEvents.toString(),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: dashboardCard(
              color: Colors.pink,
              icon: Icons.favorite_border_outlined,
              title: 'Likes',
              data: likes.toString(),
            ),
          ),
        ],
      ),
    );
  }
}