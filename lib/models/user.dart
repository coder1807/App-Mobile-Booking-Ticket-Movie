import 'dart:convert';

class User {
  final int id;
  final String? email;
  final String? phone;
  final String? username;
  final String? fullname;
  final String? address;
  final int? age;

  User(
    this.id,
    this.email,
    this.phone,
    this.username,
    this.fullname,
    this.address,
    this.age,
  );
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        phone = json['phone'],
        username = json['username'],
        fullname = json['fullname'],
        address = json['address'],
        age = json['age'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'username': username,
        'fullname': fullname,
        'address': address,
        'age': age,
      };
}
