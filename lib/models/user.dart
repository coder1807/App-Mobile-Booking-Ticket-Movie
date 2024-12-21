class User {
  final int id;
  final String? email;
  final String? phone;
  final String? username;
  final String? fullname;
  final String? address;
  final DateTime? birthday;
  final String? type;

  User(this.id, this.email, this.phone, this.username, this.fullname,
      this.address, this.birthday, this.type);
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        phone = json['phone'],
        username = json['username'],
        fullname = json['fullname'],
        address = json['address'],
        birthday = DateTime.parse(json['birthday']),
        type = json['type'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'username': username,
        'fullname': fullname,
        'address': address,
        'birthday': birthday?.toIso8601String(),
        'type': type
      };
}
