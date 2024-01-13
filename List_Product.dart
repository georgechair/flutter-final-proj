class List_Product {
  int id;
  String name ; // Change the type to String
  String price;
  int quantity;

  List_Product(this.id, this.name, this.price, this.quantity);

  @override
  String toString() {
    return "ID: $id - $name - price: $price";
  }
}

List<List_Product> data = [];
