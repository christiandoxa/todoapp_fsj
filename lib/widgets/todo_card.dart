import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final String id;
  final String title;
  final String desc;
  final DateTime deadline;
  final Function onTap;

  const TodoCard({
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${deadline.day}/${deadline.month}/${deadline.year}'),
            Text('${deadline.hour}:${deadline.minute}'),
          ],
        ),
      ),
    );
  }
}
