import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  final String id;
  final String title;
  final String desc;
  final DateTime deadline;

  const ToDoCard({
    Key key,
    @required this.id,
    @required this.title,
    @required this.desc,
    @required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          desc,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(deadline.toString()),
      ),
    );
  }
}
