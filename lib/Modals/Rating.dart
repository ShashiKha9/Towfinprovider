
class Rating{

int id;
int request_id;
int user_id;
int provider_id;
int user_rating;
int provider_rating;
String user_comment;
String provider_comment;

Rating(
{this.id,
this.request_id,
this.user_id,
this.provider_id,
this.user_rating,
this.provider_rating,
this.user_comment,
this.provider_comment,
});

Rating.fromJson(Map<String, dynamic> json) {
id = json['id'];
request_id = json['request_id'];
user_id = json['user_id'];
provider_id = json['provider_id'];
user_rating = json['user_rating'];
provider_rating = json['provider_rating'];
user_comment = json['user_comment'];
provider_comment = json['provider_comment'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['id'] = this.id;
data['request_id'] = this.request_id;
data['user_id'] = this.user_id;
data['provider_id'] = this.provider_id;
data['user_rating'] = this.user_rating;
data['provider_rating'] = this.provider_rating;
data['user_comment'] = this.user_comment;
data['provider_comment'] = this.provider_comment;
return data;
}
}