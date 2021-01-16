import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp_fsj/widgets/task_form.dart';

class EditTaskScreen extends StatefulWidget {
  final String id;
  final String title;
  final String desc;
  final Timestamp deadline;

  EditTaskScreen({
    Key key,
    @required this.id,
    @required this.title,
    @required this.deadline,
    this.desc,
  }) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
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
    _titleController.text = widget.title;
    _descController.text = widget.desc;
    _deadline = widget.deadline;
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _descController?.dispose();
    super.dispose();
  }

  void _onEditTask() async {
    if (!_loading && _formKey.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await tasks.doc(widget.id).update({
          "title": _titleController.text,
          "description": _descController.text,
          "deadline": _deadline,
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
        title: Text('Ubah'),
      ),
      body: SingleChildScrollView(
        child: TaskForm(
          formKey: _formKey,
          titleController: _titleController,
          descController: _descController,
          deadline: _deadline,
          onSubmit: _onEditTask,
          loading: _loading,
          btnText: 'Ubah',
        ),
      ),
    );
  }
}
