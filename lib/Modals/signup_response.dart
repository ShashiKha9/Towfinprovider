class SignUpResponse {
  final String login_by;
  final String first_name;
  final String last_name;
  final String email;
  final String mobile;
  final String picture;
  final String social_unique_id;
  final String device_type;
  final String device_id;
  final String device_token;
  final String payment_mode;
  final String updated_at;
  final int id;

  SignUpResponse(this.login_by
      ,this.first_name
      ,this.last_name
      ,this.email
      ,this.mobile
      ,this.picture
      ,this.social_unique_id
      ,this.device_type
      ,this.device_id
      ,this.device_token
      ,this.payment_mode
      ,this.updated_at
      ,this.id

      );

  SignUpResponse.fromJson(Map<String, dynamic> json)
      : login_by=json["login_by"],
        first_name=json["first_name"],
        last_name=json["last_name"],
        email=json["email"],
        mobile=json["mobile"],
        picture=json["picture"],
        social_unique_id=json["social_unique_id"],
        device_type=json["device_type"],
        device_id=json["device_id"],
        device_token=json["device_token"],
        payment_mode=json["payment_mode"],
        updated_at=json["updated_at"],
        id=json["id"];

  SignUpResponse.withError(String errorValue)
      : login_by = errorValue,
        first_name = errorValue,
        last_name = errorValue,
        email = errorValue,
        mobile = errorValue,
        picture = errorValue,
        social_unique_id = errorValue,
        device_type = errorValue,
        device_id = errorValue,
        device_token = errorValue,
        payment_mode = errorValue,
        updated_at = errorValue,
        id = 0;
}