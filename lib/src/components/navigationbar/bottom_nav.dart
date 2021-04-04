import 'package:flutter/material.dart';
import 'package:organiser_app/src/components/navigationbar/navigation_item.dart';
import 'package:organiser_app/src/localization/translate_helper.dart';


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
                title: getTranslate(context, "events"),
                isActive: currentIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: Icons.qr_code_scanner,
                title: getTranslate(context, "attendance"),
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.dashboard,
                title: getTranslate(context, "dashboard"),
                isActive: currentIndex == 2,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(3),
              child: BottomNavItem(
                icon: Icons.account_box,
                title: getTranslate(context, "account"),
                isActive: currentIndex == 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
