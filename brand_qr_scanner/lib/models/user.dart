class User {
  String? id;
  String? email;
  String? name;
  String? password;
  String? phone;
  String? address;
  String? roleid;
  String? origin;
  String? regdate;

  User({
    this.id,
    this.email,
    this.name,
    this.password,
    this.phone,
    this.address,
    this.roleid,
    this.origin,
    this.regdate,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    phone = json['phone'];
    address = json['address'];
    roleid = json['roleid'];
    origin = json['origin'];
    regdate = json['regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['phone'] = phone;
    data['address'] = address;
    data['roleid'] = address;
    data['origin'] = address;
    data['regdate'] = regdate;
    return data;
  }
}
