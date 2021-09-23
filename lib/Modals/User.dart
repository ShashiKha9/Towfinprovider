class User{
  int id;
  String firstName;
  String lastName;
  String paymentMode;
  String email;
  String gender;
  String mobile;
  String picture;
  String deviceToken;
  String deviceId;
  String deviceType;
  String loginBy;
  String socialUniqueId;
  double latitude;
  double longitude;
  String stripeCustId;
  int walletBalance;
  String rating;
  int otp;
  String updatedAt;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.paymentMode,
        this.email,
        this.gender,
        this.mobile,
        this.picture,
        this.deviceToken,
        this.deviceId,
        this.deviceType,
        this.loginBy,
        this.socialUniqueId,
        this.latitude,
        this.longitude,
        this.stripeCustId,
        this.walletBalance,
        this.rating,
        this.otp,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    paymentMode = json['payment_mode'];
    email = json['email'];
    gender = json['gender'];
    mobile = json['mobile'];
    picture = json['picture'];
    deviceToken = json['device_token'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    loginBy = json['login_by'];
    socialUniqueId = json['social_unique_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    stripeCustId = json['stripe_cust_id'];
    walletBalance = json['wallet_balance'];
    rating = json['rating'];
    otp = json['otp'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['payment_mode'] = this.paymentMode;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['picture'] = this.picture;
    data['device_token'] = this.deviceToken;
    data['device_id'] = this.deviceId;
    data['device_type'] = this.deviceType;
    data['login_by'] = this.loginBy;
    data['social_unique_id'] = this.socialUniqueId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['stripe_cust_id'] = this.stripeCustId;
    data['wallet_balance'] = this.walletBalance;
    data['rating'] = this.rating;
    data['otp'] = this.otp;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}