import 'package:cbx_driver/components/text_field_container.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,

        onChanged: onChanged,
        cursorColor: AppTheme.nearlyBlack,
        decoration: InputDecoration(

          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: AppTheme.nearlyBlack,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: AppTheme.nearlyBlack,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
