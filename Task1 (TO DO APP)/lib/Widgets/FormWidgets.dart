import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_app/Globals/Constants.dart';

Widget customTextfield({
  required TextEditingController controller,
  TextInputType type = TextInputType.name,
  Color borderColor = Colors.black,
  Color fillColor = Colors.white,
  String label = "Enter Text",
  bool keepBorder = true,
  bool enabled = true,
  bool multiLine = true,
  Widget leading = const SizedBox(),
  Widget trailing = const SizedBox(),
}) {
  return TextFormField(
    keyboardType: type,
    controller: controller,
    maxLines: multiLine ? null : 1,
    style: titleStyle,
    enabled: enabled,
    onChanged: (value) {},
    decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        focusColor: Colors.blue,
        labelText: label,
        labelStyle: titleStyle,
        prefixIcon: leading,
        suffixIcon: trailing,
        border: keepBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(10))
            : null),
  );
}

Widget customPasswordfield(
    {required TextEditingController controller,
    TextInputType type = TextInputType.name,
    Color borderColor = Colors.black,
    String label = "Enter Text",
    Widget leading = const SizedBox(),
    Widget trailing = const SizedBox(),
    bool obsicure = true}) {
  return TextFormField(
    keyboardType: type,
    obscureText: obsicure,
    controller: controller,
    style: titleStyle,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.blue,
        labelText: label,
        labelStyle: titleStyle,
        prefixIcon: leading,
        suffixIcon: trailing,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(10))),
  );
}

Widget customButton(
    {required String text,
    required Function onTap,
    Color bgColor = Colors.blue,
    Color fgColor = Colors.white,
    Widget leading = const SizedBox(),
    double height = 50,
    double width = 600,
    bool loader = false,
    double borderRadius = 100}) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        foregroundColor: fgColor,
        backgroundColor: bgColor,
        shadowColor: Colors.grey.shade800,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size.fromHeight(height),
      ),
      child: loader
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leading,
                Text(text),
              ],
            ),
    ),
  );
}

Widget decoratedListTile({
  required String title,
  String subtitle = "",
  List<Color> bgColors = const [],
  Color fgColor = Colors.white,
  double borderRadius = 0,
  Widget? leading,
  Widget? trailing,
}) {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: bgColors),
        borderRadius: BorderRadius.circular(borderRadius)),
    child: ListTile(
      title: Text(
        title,
        style: titleStyle.copyWith(color: fgColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: (leading != null) ? leading : null,
      trailing: (trailing != null) ? trailing : null,
    ),
  );
}
