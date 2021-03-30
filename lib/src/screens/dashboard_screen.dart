import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/dashboard/dashboard_events_card.dart';
import 'package:organiser_app/src/services/dashboard/dashboardInfo.dart';

class DashboardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Events',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            DashboardEventsCard(),
            DashboardInfo(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}






