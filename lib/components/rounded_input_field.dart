import 'package:cbx_driver/components/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType boardType;
  final TextInputFormatter formater;
  final ValueChanged<String> onChanged;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.boardType,
    this.formater,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child:
      TextField(
        keyboardType: boardType,
        inputFormatters:<TextInputFormatter>[formater],
        cursorColor: AppTheme.nearlyBlack,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: AppTheme.nearlyBlack,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
