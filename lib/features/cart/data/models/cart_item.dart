import '../../../home/data/models/card_model.dart';

class CartItem {
  final CardModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}
