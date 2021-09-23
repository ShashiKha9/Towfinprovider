class ChangePasswordRespo {
  final String message;

  ChangePasswordRespo(
      this.message
      );

  ChangePasswordRespo.fromJson(Map<String, dynamic> json)
      : message=json["message"];

  ChangePasswordRespo.withError(String errorValue)
      : message = errorValue;
}