import 'package:flutter/material.dart';
import 'package:kudosware/feature/home/home.dart';

class KudoswareApp extends StatelessWidget {
  const KudoswareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
