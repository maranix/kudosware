import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/app/app.dart';
import 'package:kudosware/feature/edit_student/edit_student.dart';
import 'package:kudosware/feature/students_overview/view/students_overview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kudosware'),
        actions: const [
          AppBarLogoutButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homePage_addStudent_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditStudentPage.route()),
        child: const Icon(Icons.add),
      ),
      body: const StudentsOverviewPage(),
    );
  }
}

class AppBarLogoutButton extends StatelessWidget {
  const AppBarLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: 'Logout',
      onPressed: () => context.read<AppBloc>().add(const AppLogoutRequested()),
      icon: const Icon(Icons.logout),
    );
  }
}
