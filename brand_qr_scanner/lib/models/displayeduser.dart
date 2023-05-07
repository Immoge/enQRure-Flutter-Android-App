class DisplayedUser {
  String? userId;
  String? userEmail;
  String? userName;
  String? userPassword;
  String? userPhone;
  String? userAddress;
  String? roleId;
  String? userOrigin;
  String? userRegDate;

  DisplayedUser({
    this.userId,
    this.userEmail,
    this.userName,
    this.userPassword,
    this.userPhone,
    this.userAddress,
    this.roleId,
    this.userOrigin,
    this.userRegDate,
  });

  DisplayedUser.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userPassword = json['user_password'];
    userPhone = json['user_phone'];
    userAddress = json['user_homeAddress'];
    roleId = json['role_id'];
    userOrigin = json['user_origin'];
    userRegDate = json['user_datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    data['user_password'] = userPassword;
    data['user_phone'] = userPhone;
    data['user_homeAddress'] = userAddress;
    data['role_id'] = roleId;
    data['user_origin'] = userOrigin;
    data['user_datereg'] = userRegDate;
    return data;
  }
}
