import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizify/Globals/constants.dart';

Widget customTextfield(
    {required TextEditingController controller,
    TextInputType type = TextInputType.name,
    Color borderColor = Colors.black,
    Color fillColor = Colors.white,
    String label = "Enter Text",
    bool keepBorder = true,
    bool enabled = true,
    bool multiLine = true,
    TextStyle? labelStyle,
    Widget? leading,
    Widget? trailing,
    void Function(String)? onChanged,
    double? textfieldHeight}) {
  return TextFormField(
    keyboardType: type,
    controller: controller,
    style: style,
    enabled: enabled,
    onChanged: onChanged,
    minLines: textfieldHeight != null ? null : 1,
    maxLines: textfieldHeight != null ? null : (multiLine ? null : 1),
    decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        focusColor: Colors.blue,
        labelText: label,
        labelStyle: labelStyle ?? style,
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
    style: style,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.blue,
        labelText: label,
        labelStyle: style,
        prefixIcon: leading,
        suffixIcon: trailing,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(10))),
  );
}

Widget picker(String placeHolder) {
  return DottedBorder(
    radius: const Radius.circular(20),
    dashPattern: const [4, 4],
    child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            placeHolder,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )),
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
        style: style.copyWith(color: fgColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: (leading != null) ? leading : null,
      trailing: (trailing != null) ? trailing : null,
    ),
  );
}
