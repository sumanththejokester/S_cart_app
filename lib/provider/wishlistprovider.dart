import 'package:flutter/foundation.dart';
import 'package:multi_store_app/provider/providerclass.dart';

class WishList extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWishItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addWishlistItem(
    String name,
    double price,
    int qnty,
    int quantity,
    List imagesUrl,
    String documentId,
    String suppId,
  ) async {
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

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishlist() {
    _list.clear();
    notifyListeners();
  }

  void removethis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
