import 'dart:convert';

class User {
  final int id;
  final String? email;
  final String? phone;
  final String? username;
  final String? fullname;
  final String? address;

  User(
    this.id,
    this.email,
    this.phone,
    this.username,
    this.fullname,
    this.address,
  );
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullname = json['fullname'],
        username = json['username'],
        email = json['email'],
        phone = json['phone'],
        address = json['address'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'username': username,
        'phone': phone,
        'address': address,
        'email': email
      };
}
