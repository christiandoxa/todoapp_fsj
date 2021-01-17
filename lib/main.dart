import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp_fsj/screens/home_screen.dart';
import 'package:todoapp_fsj/screens/login_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('logo');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: initializationSettingsAndroid,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final User _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _currentUser == null
          ? LoginScreen()
          : HomeScreen(name: _currentUser.displayName),
    );
  }
}
