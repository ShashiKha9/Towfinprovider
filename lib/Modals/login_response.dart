class LoginResponse {
  final String access_token;
  // final String refresh_token;
  final String currency;

  LoginResponse(this.access_token, this.currency);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : access_token=json["access_token"],
        currency=json["currency"];

  LoginResponse.withError(String errorValue)
      : access_token = errorValue,
        currency = errorValue;
}