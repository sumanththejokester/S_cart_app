class Product {
  String name;
  double price;
  int qty = 1;
  int quantity;
  List imagesUrl;
  String documentId;
  String suppId;
  Product(
      {required this.name,
      required this.price,
      required this.qty,
      required this.quantity,
      required this.imagesUrl,
      required this.documentId,
      required this.suppId});
  void increament() {
    qty++;
  }

  void decreament() {
    qty--;
  }
}