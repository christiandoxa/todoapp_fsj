import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final Timestamp deadline;
  final Function(Timestamp deadline) onSubmit;
  final bool loading;
  final String btnText;

  const TaskForm({
    Key key,
    @required this.formKey,
    @required this.titleController,
    @required this.descController,
    @required this.deadline,
    @required this.onSubmit,
    @required this.loading,
    @required this.btnText,
  }) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  Timestamp _deadline;

  @override
  void initState() {
    super.initState();
    _deadline = widget.deadline;
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
    final DateTime _date = _deadline.toDate();

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
              ),
              validator: (value) {
                if (value.isEmpty) return 'Masukkan judul';
                return null;
              },
            ),
            TextFormField(
              controller: widget.descController,
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
                onPressed:
                    widget.loading ? null : () => widget.onSubmit(_deadline),
                child: widget.loading
                    ? CircularProgressIndicator()
                    : Text(widget.btnText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
