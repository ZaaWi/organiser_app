

class Category {
  int id;
  String name;

  Category({this.id, this.name});

  int getCategoryIDbyName (String categoryName) {
    if(this.name == categoryName) {
      return this.id;
    } else {
      return null;
    }
  }

}