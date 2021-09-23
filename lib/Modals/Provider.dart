
class Provider{
int id;
String firstName;
String lastName;
String email;
String gender;
String mobile;
String avatar;
String rating;
String status;
int fleet;
double latitude;
double longitude;
int otp;
Provider(
{this.id,
this.firstName,
this.lastName,
this.email,
this.gender,
this.mobile,
this.avatar,
this.rating,
this.status,
this.fleet,
this.latitude,
this.longitude,
this.otp,
});

Provider.fromJson(Map<String, dynamic> json) {
id = json['id'];
firstName = json['first_name'];
lastName = json['last_name'];
email = json['email'];
gender = json['gender'];
mobile = json['mobile'];
avatar = json['avatar'];
rating = json['rating'];
status = json['status'];
fleet = json['fleet'];

latitude = json['latitude'];
longitude = json['longitude'];

otp = json['otp'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['id'] = this.id;
data['first_name'] = this.firstName;
data['last_name'] = this.lastName;
data['email'] = this.email;
data['gender'] = this.gender;
data['mobile'] = this.mobile;
data['avatar'] = this.avatar;
data['rating'] = this.rating;
data['status'] = this.status;
data['fleet'] = this.fleet;

data['latitude'] = this.latitude;
data['longitude'] = this.longitude;

data['otp'] = this.otp;
return data;
}
}