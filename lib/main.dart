import 'package:bill_management_app/views/screen/homeScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(BillManagementApp());

class BillManagementApp extends StatelessWidget {
  const BillManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bill Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}