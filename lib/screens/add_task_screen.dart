import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todoapp_fsj/helpers/firebase_storage.dart';
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
  void dispose() {
    _titleController?.dispose();
    _descController?.dispose();
    super.dispose();
  }

  void _onAddTask(Timestamp deadline, File file) async {
    if (!_loading && _formKey.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        String attachment;
        if (file != null) {
          UploadTask task = await uploadFile(file);
          TaskSnapshot taskSnapshot = await task;
          attachment = await taskSnapshot.ref.getDownloadURL();
        }
        await tasks.add({
          "title": _titleController.text,
          "description": _descController.text,
          "deadline": deadline,
          "attachment": attachment,
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
