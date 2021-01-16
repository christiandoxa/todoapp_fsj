import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Timestamp _deadline = Timestamp.now();
  bool _loading = false;

  @override
  void dispose() {
    _titleController?.dispose();
    _descController?.dispose();
    super.dispose();
  }

  void _onAddTask() {
    if (!_loading && _formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
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
