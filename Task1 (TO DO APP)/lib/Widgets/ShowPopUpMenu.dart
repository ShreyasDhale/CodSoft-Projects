import 'package:flutter/material.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Constants.dart';

class OptionsList extends StatelessWidget {
  final int id;
  final Function refresh;
  final Function showForm;
  const OptionsList(
      {super.key,
      required this.refresh,
      required this.id,
      required this.showForm});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          onTap: () {
            showForm(context, id);
          },
          child: ListTile(
            title: Text(
              'Update',
              style: titleStyle,
            ),
            leading: const Icon(
              Icons.update,
              color: Colors.black,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          onTap: () async {
            await SQLHelper.completeTask(id);
            refresh(null);
          },
          child: ListTile(
            title: Text(
              'Completed',
              style: titleStyle,
            ),
            leading: const Icon(
              Icons.verified,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
