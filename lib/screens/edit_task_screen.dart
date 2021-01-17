import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp_fsj/helpers/notification.dart';
import 'package:todoapp_fsj/widgets/task_form.dart';

class EditTaskScreen extends StatefulWidget {
  final String id;
  final String title;
  final String desc;
  final Timestamp deadline;
  final int notificationId;

  EditTaskScreen({
    Key key,
    @required this.id,
    @required this.title,
    @required this.deadline,
    @required this.notificationId,
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
  bool _loadingDelete = false;

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

  void _onEditTask(Timestamp deadline) async {
    if (!_loading && _formKey.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await addOrEditNotification(
          notificationId: widget.notificationId,
          title: _titleController.text,
          description: _descController.text,
          deadline: deadline,
        );
        await tasks.doc(widget.id).update({
          "title": _titleController.text,
          "description": _descController.text,
          "deadline": deadline,
        });
        Navigator.of(context).pop();
      } catch (error) {
        setState(() {
          _loading = false;
        });
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Error edit data ${error.toString()}",
            ),
          ),
        );
        print(error);
      }
    }
  }

  void _onDelete() async {
    try {
      setState(() {
        _loadingDelete = true;
      });
      await tasks.doc(widget.id).delete();
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _loadingDelete = false;
      });
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Error delete data")));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Ubah'),
        actions: [
          _loadingDelete
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _onDelete,
                ),
        ],
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
