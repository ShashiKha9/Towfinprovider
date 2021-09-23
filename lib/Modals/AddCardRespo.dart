import 'User.dart';

class AddCardRespo {
  final String message;

  AddCardRespo(
      this.message,
      );

  AddCardRespo.fromJson(Map<String, dynamic> json)
      : message=json["message"];



  AddCardRespo.withError(String errorValue)
      : message = errorValue;
}
