import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'statistic_page.dart';
import 'profile_page.dart';
import 'profile_settings_page.dart';
import 'transaction.dart';
import 'splash_screen.dart'; // Tambahkan impor ini

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transaction> transactions = [];
  final Map<String, String> users = {};
  String username = 'Nama User';

  void updateUsername(String newUsername) {
    setState(() {
      username = newUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Ubah home menjadi SplashScreen
      routes: {
        '/login': (context) => LoginPage(users: users),
        '/register': (context) => RegisterPage(users: users),
        '/home': (context) => HomePage(transactions: transactions),
        '/statistics': (context) => StatisticPage(transactions),
        '/profile': (context) => ProfilePage(username: username),
        '/profile-settings': (context) => ProfileSettingsPage(username: username, updateUsername: updateUsername),
      },
    );
  }
}
