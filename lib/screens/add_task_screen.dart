import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp_fsj/main.dart';
import 'package:todoapp_fsj/widgets/task_form.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference tasks = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('tasks');
  Timestamp _deadline = Timestamp.now();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _descController?.dispose();
    super.dispose();
  }

  void _onAddTask(Timestamp deadline) async {
    if (!_loading && _formKey.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await flutterLocalNotificationsPlugin.zonedSchedule(
          Random().nextInt(1000000),
          _titleController.text,
          _descController.text,
          tz.TZDateTime.from(deadline.toDate(), tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'deadline',
              'Deadline Tasks',
              'Deadline for tasks',
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        await tasks.add({
          "title": _titleController.text,
          "description": _descController.text,
          "deadline": deadline,
        });
        Navigator.of(context).pop();
      } catch (error) {
        setState(() {
          _loading = false;
        });
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Error add data")));
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tambah'),
      ),
      body: SingleChildScrollView(
        child: TaskForm(
          formKey: _formKey,
          titleController: _titleController,
          descController: _descController,
          deadline: _deadline,
          onSubmit: _onAddTask,
          loading: _loading,
          btnText: 'Tambah',
        ),
      ),
    );
  }
}
