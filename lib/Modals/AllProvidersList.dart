class AllProvidersList{
  int id;
  String first_name;
  String last_name;
  String email;
  String gender;
  String mobile;
  String avatar;
  String rating;
  String status;
  double latitude;
  double longitude;
  int otp;

  AllProvidersList(
      {
        this.id,
        this.first_name,
        this.last_name,
        this.email,
        this.gender,
        this.mobile,
        this.avatar,
        this.rating,
        this.status,
        this.latitude,
        this.longitude,
        this.otp

      });

  AllProvidersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    mobile = json['mobile'];
    avatar = json['avatar'];
    rating = json['rating'];
    status = json['status'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    otp = json['otp'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['avatar'] = this.avatar;
    data['avatar'] = this.avatar;
    data['rating'] = this.rating;
    data['status'] = this.status;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['otp'] = this.otp;
    return data;
  }
}