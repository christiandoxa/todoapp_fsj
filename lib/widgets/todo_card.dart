import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  final String id;
  final String title;
  final String desc;
  final DateTime deadline;
  final Function onTap;

  const ToDoCard({
    Key key,
    @required this.id,
    @required this.title,
    @required this.deadline,
    @required this.onTap,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: desc != null && desc.isNotEmpty
            ? Text(
                desc,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Column(
          children: [
            Text('${deadline.day}/${deadline.month}/${deadline.year}'),
            Text('${deadline.hour}:${deadline.minute}'),
          ],
        ),
      ),
    );
  }
}
