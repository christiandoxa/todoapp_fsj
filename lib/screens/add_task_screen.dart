import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void _onAddTask() async {
    if (!_loading && _formKey.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await tasks.add({
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

  void _selectDate() async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: _deadline.toDate(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3600)),
    );
    if (selected != null) {
      setState(() {
        _deadline = Timestamp.fromDate(DateTime(
          selected.year,
          selected.month,
          selected.day,
          _deadline.toDate().hour,
          _deadline.toDate().minute,
        ));
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline.toDate()),
    );
    if (selected != null) {
      setState(() {
        _deadline = Timestamp.fromDate(DateTime(
          _deadline.toDate().year,
          _deadline.toDate().month,
          _deadline.toDate().day,
          selected.hour,
          selected.minute,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date = _deadline.toDate();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tambah'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Masukkan judul';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    'Tanggal',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                InkWell(
                  onTap: _selectDate,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text('${_date.day}/${_date.month}/${_date.year}'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    'Tanggal',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                InkWell(
                  onTap: _selectTime,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text('${_date.hour}:${_date.minute}'),
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: _loading ? null : _onAddTask,
                    child:
                    _loading ? CircularProgressIndicator() : Text('Tambah'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
