import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/feature/edit_student/bloc/edit_student_bloc.dart';

class EditStudentPage extends StatelessWidget {
  const EditStudentPage({super.key});

  static Route<void> route({Student? student}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditStudentBloc(
          repo: context.read<StudentRepository>(),
          student: student,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditStudentBloc, EditStudentState>(
      listenWhen: (prev, curr) {
        return prev.status != curr.status &&
            curr.status == EditStudentStatus.success;
      },
      listener: (context, state) {
        return switch (state.status) {
          EditStudentStatus.failure =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'An unknown error occurred.',
                ),
              ),
            ),
          EditStudentStatus.success => Navigator.of(context).pop(),
          _ => null,
        };
      },
      child: const _EditStudentView(),
    );
  }
}

class _EditStudentView extends StatelessWidget {
  const _EditStudentView();

  @override
  Widget build(BuildContext context) {
    final isEditing = context.read<EditStudentBloc>().state.isEditing;

    // TODO:
    //
    // 1. Add Text/Dropdown widgets for form fields and perform basic validation as well.
    //    I need date picker for DOB.
    // 2. Bind the actions to the bloc.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Student' : 'Add Student',
        ),
      ),
    );
  }
}
