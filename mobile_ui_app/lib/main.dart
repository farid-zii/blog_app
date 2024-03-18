import 'package:flutter/material.dart';
import 'package:mobile_ui_app/screen/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Loading());
  }
}
