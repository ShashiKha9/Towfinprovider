import 'User.dart';

class ForgetPasswordRespo {
  final String message;
  User user;

  ForgetPasswordRespo(
      this.message,
      this.user
      );

  ForgetPasswordRespo.fromJson(Map<String, dynamic> json)
      : message=json["message"],
        user = User.fromJson(json['user']);




  ForgetPasswordRespo.withError(String errorValue)
      : message = errorValue;
}
