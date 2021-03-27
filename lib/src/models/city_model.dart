



class City {
  int id;
  String name;

  City({this.id, this.name});

  int getCityIDbyName (String cityName) {
    if (this.name == cityName) {
      return this.id;
    }else {
      return null;
    }
  }


}