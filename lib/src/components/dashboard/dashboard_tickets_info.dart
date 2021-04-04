
import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/dashboard/dashboard_card.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';

class DashboardTicketsInfo extends StatelessWidget {
  final int tickets;
  final int booked;
  final int attended;

  DashboardTicketsInfo({this.tickets, this.booked, this.attended});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: dashboardCard(
              color: Colors.blue,
              icon: Icons.confirmation_num_outlined,
              title: getTranslate(context, "Tickets"),
              data: tickets.toString(),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: dashboardCard(
              color: Colors.blue,
              icon: Icons.bookmarks_outlined,
              title: getTranslate(context, "booked"),
              data: booked.toString(),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: dashboardCard(
              color: Colors.blue,
              icon: Icons.style_outlined,
              title: getTranslate(context, "attended"),
              data: attended.toString(),
            ),
          ),
        ],
      ),
    );
  }
}