import 'package:flutter/cupertino.dart';
import 'package:multi_store_app/provider/providerclass.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalprice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(
    String name,
    double price,
    int qnty,
    int quantity,
    List imagesUrl,
    String documentId,
    String suppId,
  ) {
    final product = Product(
        name: name,
        price: price,
        qty: qnty,
        quantity: quantity,
        imagesUrl: imagesUrl,
        documentId: documentId,
        suppId: suppId);
    _list.add(product);
    notifyListeners();
  }

  void increase(Product product) {
    product.increament();
    notifyListeners();
  }

  void decrease(Product product) {
    product.decreament();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
