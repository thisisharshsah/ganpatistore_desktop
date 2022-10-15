class UserModel {
  String? docId;
  String? name;
  String? phoneNumber;
  String? address;

  UserModel({
    this.docId,
    this.name,
    this.phoneNumber,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        docId: json["docId"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "name": name,
        "phoneNumber": phoneNumber,
        "address": address,
      };

  static fromMap(user) {
    return UserModel(
      docId: user['docId'],
      name: user['name'],
      phoneNumber: user['phoneNumber'],
      address: user['address'],
    );
  }
}
