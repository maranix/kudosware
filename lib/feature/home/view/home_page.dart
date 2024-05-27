import 'package:flutter/material.dart';
import 'package:kudosware/feature/edit_student/edit_student.dart';
import 'package:kudosware/feature/students_overview/view/students_overview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditStudentPage.route()),
        child: const Icon(Icons.add),
      ),
      body: const StudentsOverviewPage(),
    );
  }
}
