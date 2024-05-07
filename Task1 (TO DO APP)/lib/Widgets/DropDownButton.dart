import 'package:flutter/material.dart';
import 'package:to_do_app/Globals/Variables.dart';

class DecoratedDropdownButton extends StatefulWidget {
  final List<String> items;
  final EdgeInsetsGeometry padding;
  final BoxDecoration decoration;
  final String buttonType;
  final Function setType;
  final Function setRepete;

  const DecoratedDropdownButton({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.all(8.0),
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    required this.setType,
    required this.setRepete,
    required this.buttonType,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DecoratedDropdownButtonState createState() =>
      _DecoratedDropdownButtonState();
}

class _DecoratedDropdownButtonState extends State<DecoratedDropdownButton> {
  List<DropdownMenuItem<String>> items = [];
  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    List<DropdownMenuItem<String>> data = [];
    for (int i = 0; i < widget.items.length; i++) {
      data.add(DropdownMenuItem(
          value: widget.items[i], child: Text(widget.items[i])));
    }
    setState(() {
      selectedValue = widget.items.first;
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: widget.decoration,
      child: DropdownButton<String>(
        value: selectedValue,
        items: items,
        onChanged: (value) {
          setState(() {
            selectedValue = value!;
          });
          Print(selectedValue);
          if (widget.buttonType == "Type") {
            widget.setType(selectedValue);
          } else {
            widget.setRepete(selectedValue);
          }
        },
      ),
    );
  }
}
