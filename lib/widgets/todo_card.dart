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
    @required this.deadline,
    this.desc,
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
        subtitle: desc != null
            ? Text(
                desc,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Text('${deadline.day}/${deadline.month}/${deadline.year}'),
      ),
    );
  }
}
