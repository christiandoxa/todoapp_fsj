import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp_fsj/screens/add_task_screen.dart';
import 'package:todoapp_fsj/screens/login_screen.dart';
import 'package:todoapp_fsj/widgets/todo_card.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  HomeScreen({
    Key key,
    @required this.name,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  StreamController<QuerySnapshot> documentStream =
      StreamController<QuerySnapshot>();

  @override
  void initState() {
    super.initState();
    documentStream.addStream(
      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .collection("tasks")
          .snapshots(),
    );
  }

  @override
  void dispose() {
    documentStream.close();
    super.dispose();
  }

  void _goToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
  }

  void _onLogout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List - ${widget.name}'),
        actions: [
          IconButton(
            onPressed: _onLogout,
            tooltip: 'Keluar',
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: documentStream.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("error")));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          List<QueryDocumentSnapshot> list = snapshot.data.docs;
          return ListView.builder(
            itemBuilder: (BuildContext context, int position) {
              QueryDocumentSnapshot document = list[position];
              return ToDoCard(
                id: document.id,
                title: document.data()["title"],
                desc: document.data()["description"],
                deadline: (document.data()["deadline"] as Timestamp).toDate(),
              );
            },
            itemCount: list.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddScreen,
        tooltip: 'Tambah',
        child: Icon(Icons.add),
      ),
    );
  }
}
