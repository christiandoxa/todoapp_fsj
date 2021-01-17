import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TaskForm extends StatefulWidget {
  final bool loading;
  final Function(Timestamp deadline, File file) onSubmit;
  final GlobalKey<FormState> formKey;
  final String btnText;
  final String imageUrl;
  final TextEditingController descController;
  final TextEditingController titleController;
  final Timestamp deadline;

  const TaskForm({
    Key key,
    @required this.formKey,
    @required this.titleController,
    @required this.descController,
    @required this.onSubmit,
    @required this.loading,
    @required this.btnText,
    this.deadline,
    this.imageUrl,
  }) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _picker = ImagePicker();
  File _image;
  Timestamp _deadline;

  @override
  void initState() {
    super.initState();
    _deadline = widget.deadline ?? Timestamp.now();
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

  void _selectImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
                'Jam',
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
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                'Lampiran',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            InkWell(
              onTap: _selectImage,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(_image == null ? 'Pilih gambar' : 'Ubah gambar'),
              ),
            ),
            _image != null
                ? Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(child: Image.file(_image, height: 200)),
                  )
                : SizedBox(),
            _image == null && widget.imageUrl != null
                ? Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(
                      child: Image.network(widget.imageUrl, height: 200),
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 18),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: widget.loading
                    ? null
                    : () => widget.onSubmit(_deadline, _image),
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
