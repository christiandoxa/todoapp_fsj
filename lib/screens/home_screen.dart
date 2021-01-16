import 'package:flutter/material.dart';
import 'package:todoapp_fsj/screens/add_task_screen.dart';
import 'package:todoapp_fsj/screens/login_screen.dart';
import 'package:todoapp_fsj/widgets/todo_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _goToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
  }

  void _onLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
        actions: [
          IconButton(
            onPressed: _onLogout,
            tooltip: 'Keluar',
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ToDoCard(
              id: '1',
              title: 'Task A',
              desc: 'deskripsi task A',
              deadline: DateTime.now(),
            ),
            ToDoCard(
              id: '2',
              title: 'Task B',
              desc: 'deskripsi task B',
              deadline: DateTime.now(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddScreen,
        tooltip: 'Tambah',
        child: Icon(Icons.add),
      ),
    );
  }
}