class ProductModel {
  String? buyerId;
  String? buyerName;
  String? productId;
  String? productName;
  String? productPrice;
  String? productCode;
  String? productBase;
  String? createdAt;
  String? updatedAt;

  ProductModel({
    this.buyerId,
    this.buyerName,
    this.productId,
    this.productName,
    this.productPrice,
    this.productCode,
    this.productBase,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        buyerId: json["buyerId"],
        buyerName: json["buyerName"],
        productId: json["productId"],
        productName: json["productName"],
        productPrice: json["productPrice"],
        productCode: json["productCode"],
        productBase: json["productBase"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "buyerId": buyerId,
        "buyerName": buyerName,
        "productId": productId,
        "productName": productName,
        "productPrice": productPrice,
        "productCode": productCode,
        "productBase": productBase,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static fromMap(product) {
    return ProductModel(
      buyerId: product['buyerId'],
      buyerName: product['buyerName'],
      productId: product['productId'],
      productName: product['productName'],
      productPrice: product['productPrice'],
      productCode: product['productCode'],
      productBase: product['productBase'],
      createdAt: product['createdAt'],
      updatedAt: product['updatedAt'],
    );
  }
}
