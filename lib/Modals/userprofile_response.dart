class UserProfileRespo {
  final String first_name;
  final String last_name;
  final String email;
  final String mobile;
  final String picture;
  final String gender;
  final int wallet_balance;
  final String currency;
  final String sos;
  final String payment_mode;
  final String avatar;
  final String status;
  final int id;

  UserProfileRespo(
      this.first_name
      ,this.last_name
      ,this.email
      ,this.mobile
      ,this.picture
      ,this.gender
      ,this.wallet_balance
      ,this.currency
      ,this.sos
      ,this.payment_mode
      ,this.avatar
      ,this.status
      ,this.id

      );

  UserProfileRespo.fromJson(Map<String, dynamic> json)
      : first_name=json["first_name"],
        last_name=json["last_name"],
        email=json["email"],
        mobile=json["mobile"],
        picture=json["picture"],
        gender=json["gender"],
        wallet_balance=json["wallet_balance"],
        currency=json["currency"],
        sos=json["sos"],
        payment_mode=json["payment_mode"],
        avatar=json["avatar"],
        status=json["status"],
        id=json["id"];

  UserProfileRespo.withError(String errorValue)
      : first_name = errorValue,
        last_name = errorValue,
        email = errorValue,
        mobile = errorValue,
        picture = errorValue,
        gender = errorValue,
        wallet_balance = 0,
        currency = errorValue,
        sos = errorValue,
        payment_mode = errorValue,
        avatar = errorValue,
        status = errorValue,
        id = 0;
}