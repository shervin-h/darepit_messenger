import 'package:darepit_messenger/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darepit Messenger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dartThemeData,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('تا کی باید گل بچینم بعد اونا رو پر پر کنم'),),
      body: Container(),
    );
  }
}
