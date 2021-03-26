import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/navigationbar/navigation_item.dart';


class BottomNav extends StatelessWidget {

  final int currentIndex;
  final Function(int) onChange;
  const BottomNav({Key key, this.currentIndex, this.onChange})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: Icons.event,
                title: "events",
                isActive: currentIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: Icons.dashboard,
                title: "dashboard",
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.account_box,
                title: "account",
                isActive: currentIndex == 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
