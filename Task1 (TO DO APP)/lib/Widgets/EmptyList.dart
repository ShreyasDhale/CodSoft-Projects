import 'package:flutter/material.dart';
import 'package:to_do_app/Globals/Constants.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "Assets/Images/empty.png",
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.7,
            fit: BoxFit.cover,
          ),
          Text(
            "No Tasks Scheduled",
            style: headLineStyle,
          )
        ],
      ),
    );
  }
}
