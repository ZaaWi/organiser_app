import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/app.dart';
import 'package:organiser_app/src/components/navigationbar/bottom_nav.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:organiser_app/src/screens/account_screen.dart';
import 'package:organiser_app/src/screens/attendance_screen.dart';
import 'package:organiser_app/src/screens/dashboard_screen.dart';
import 'package:organiser_app/src/screens/events_screen.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentPage;

  void changeLanguage(String langCode) {
    Locale _temp;
    switch (langCode) {
      case "en":
        _temp = Locale(langCode, "US");
        break;
      case "ar":
        _temp = Locale(langCode, "LY");
        break;

      default:
        _temp = Locale(langCode, "US");
    }
    MyApp.setLocale(context, _temp);
  }

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return EventsScreen();
      case 1:
        return AttendanceScreen();
      case 2:
        return Center(
          child: Container(
            child: DashboardScreen(),
          ),
        );
      case 3:
        return AccountScreen();
    }
  }

  // Center(
  // child: Container(
  // child: FlatButton(
  // child: Text(getTranslate(context, 'account')),
  // onPressed: () {
  // changeLanguage('ar');
  // },
  // ),
  // ),
  // );

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(kGraphQLURL);
    String token = Provider.of<UserProvider>(context).user.token;

    final AuthLink auth =
        AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
    final Link link = auth.concat(httpLink);

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("organiser app"),
        // ),
        backgroundColor: Colors.grey.shade300,
        body: getPage(_currentPage),
        bottomNavigationBar: BottomNav(
            currentIndex: _currentPage,
            onChange: (index) {
              setState(() {
                _currentPage = index;
              });
            }),
      ),
    );
  }
}
