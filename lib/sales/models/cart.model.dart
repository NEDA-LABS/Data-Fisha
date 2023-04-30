class CartModel{
  dynamic quantity;
  Map<String, dynamic>? product;

  CartModel({this.product, this.quantity});

  Map<String, dynamic> toJSON() => {"quantity": quantity, "product": product};
}
