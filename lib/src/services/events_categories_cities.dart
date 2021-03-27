import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:organiser_app/src/api/api_config.dart';
import 'package:organiser_app/src/models/category_model.dart';
import 'package:organiser_app/src/models/city_model.dart';
import 'package:organiser_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

typedef void FormCallback(
  int id,
  String name,
);

class EventsCategoriesAndCities extends StatefulWidget {
  final FormCallback cityCallback;
  final FormCallback categoryCallback;

  EventsCategoriesAndCities({this.cityCallback,this.categoryCallback});

  @override
  _EventsCategoriesAndCitiesState createState() => _EventsCategoriesAndCitiesState();
}

class _EventsCategoriesAndCitiesState extends State<EventsCategoriesAndCities> {
  List<String> categoriesNames = [];
  List<String> citiesNames = [];
  String chosenCategory;
  String chosenCity;
  int chosenCategoryID;
  int chosenCityID;

  final String categoriesQuery = r"""

query getCategories {
  categories {
    id
    name
  }
}

                  """;
  final String citiesQuery = r"""

query getCities {
  cities {
    id
    name
  }
}

                  """;

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(gqlUrl);
    String token = Provider.of<UserProvider>(context).user.token;

    final AuthLink auth =
        AuthLink(headerKey: 'Authorization', getToken: () => 'Bearer $token');
    final Link link = auth.concat(httpLink);

    final ValueNotifier<GraphQLClient> categoriesClient =
        ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: categoriesClient,
      child: Query(
        options: QueryOptions(
          document: gql(categoriesQuery),
        ),
        builder: (QueryResult categoriesResult,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (categoriesResult.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          if (categoriesResult.data == null) {
            print(categoriesResult.exception);
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          }
          List<Category> categories = [];
          for (var c in categoriesResult.data['categories']) {
            Category category = Category(
              id: int.parse(c['id']),
              name: c['name'],
            );
            categories.add(category);
            categoriesNames.add(category.name);
          }

          return Query(
            options: QueryOptions(
              document: gql(citiesQuery),
            ),
            builder: (QueryResult citiesResult,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (citiesResult.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.orangeAccent,
                  ),
                );
              }
              if (citiesResult.data == null) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                );
              }
              List<City> cities = [];
              for (var c in citiesResult.data['cities']) {
                City city = City(
                  id: int.parse(c['id']),
                  name: c['name'],
                );
                cities.add(city);
                citiesNames.add(city.name);
              }
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: DropdownSearch<String>(
                        showSearchBox: true,
                        mode: Mode.DIALOG,
                        showSelectedItem: true,
                        items: categoriesNames,
                        label: 'choose category',
                        hint: 'categories menu',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'please pick a category';
                          }
                          return null;
                        },
                        onChanged: (newValue) {
                          chosenCategory = newValue;
                          for (var x in categories) {
                            if (x.name == chosenCategory) {
                              chosenCategoryID =
                                  x.getCategoryIDbyName(chosenCategory);
                            }
                          }
                          widget.categoryCallback(
                              chosenCategoryID,
                              chosenCategory,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: DropdownSearch<String>(
                        showSearchBox: true,
                        mode: Mode.DIALOG,
                        showSelectedItem: true,
                        items: citiesNames,
                        label: 'choose city',
                        hint: 'cities menu',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'please pick a city';
                          }
                          return null;
                        },
                        onChanged: (newValue) {
                          chosenCity = newValue;
                          for (var x in cities) {
                            if (x.name == chosenCity) {
                              chosenCityID = x.getCityIDbyName(chosenCity);
                            }
                          }
                          widget.cityCallback(
                            chosenCityID,
                            chosenCity,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
