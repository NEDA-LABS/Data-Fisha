class CartModel{
  double quantity;
  Map product;

  CartModel({required this.product, required this.quantity});

  Map toJSON() => {"quantity": quantity, "product": product};
}
