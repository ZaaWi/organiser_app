import 'package:flutter/material.dart';

final TextStyle whiteText = TextStyle(color: Colors.white);
Widget dashboardCard(
    {Color color, IconData icon, String title, String data}) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    height: 150.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: color,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
        ),
        Text(
          title,
          style: whiteText.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          data,
          style:
          whiteText.copyWith(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ],
    ),
  );
}