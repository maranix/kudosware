import 'package:flutter/material.dart';
import 'package:kudosware/feature/home/home.dart';

class KudoswareApp extends StatelessWidget {
  const KudoswareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xFFd6eadf),
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xff809bce),
        ),
      ),
      home: const HomePage(),
    );
  }
}
