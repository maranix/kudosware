import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/enums.dart';
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
        child: const _EditStudentView(),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Student' : 'Add Student',
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _FirstNameField(),
              _LastNameField(),
              Row(
                children: [
                  Expanded(child: _GenderField()),
                  Expanded(child: _DOBPicker()),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: const _SubmitFloatingActionButton(),
    );
  }
}

class _FirstNameField extends StatelessWidget {
  const _FirstNameField();

  @override
  Widget build(BuildContext context) {
    final status = context.select<EditStudentBloc, EditStudentStatus>(
        (bloc) => bloc.state.status);
    final initialValue = context.read<EditStudentBloc>().state.firstName;

    return TextFormField(
      key: const Key('editStudentView_firstName_textFormField'),
      initialValue: initialValue,
      decoration: InputDecoration(
        enabled: status != EditStudentStatus.loading,
        labelText: 'First Name',
        hintText: 'John',
      ),
      onChanged: (value) {
        context.read<EditStudentBloc>().add(EditStudentFirstNameChanged(value));
      },
    );
  }
}

class _LastNameField extends StatelessWidget {
  const _LastNameField();

  @override
  Widget build(BuildContext context) {
    final status = context.select<EditStudentBloc, EditStudentStatus>(
        (bloc) => bloc.state.status);
    final initialValue = context.read<EditStudentBloc>().state.lastName;

    return TextFormField(
      key: const Key('editStudentView_lastName_textFormField'),
      initialValue: initialValue,
      decoration: InputDecoration(
        enabled: status != EditStudentStatus.loading,
        labelText: 'Last Name',
        hintText: 'Doe',
      ),
      onChanged: (value) {
        context.read<EditStudentBloc>().add(EditStudentLastNameChanged(value));
      },
    );
  }
}

class _GenderField extends StatelessWidget {
  const _GenderField();

  @override
  Widget build(BuildContext context) {
    final initialValue = context.read<EditStudentBloc>().state.gender;

    return DropdownButtonFormField(
      key: const Key('editStudentView_gender_textFormField'),
      value: initialValue.isEmpty ? 'other' : initialValue,
      items: GenderEnum.values.map((g) {
        return DropdownMenuItem<String>(
          value: g.name,
          child: Text(g.name),
        );
      }).toList(),
      onChanged: (value) {
        context
            .read<EditStudentBloc>()
            .add(EditStudentGenderChanged(value ?? ''));
      },
    );
  }
}

class _DOBPicker extends StatelessWidget {
  const _DOBPicker();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<EditStudentBloc, bool>(
        (bloc) => bloc.state.status == EditStudentStatus.loading);
    final dob =
        context.select<EditStudentBloc, DateTime>((bloc) => bloc.state.dob);

    return TextButton(
      onPressed: isLoading
          ? null
          : () async {
              final pickedDOB = await showDatePicker(
                context: context,
                initialDate: dob,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDOB != null) {
                scheduleMicrotask(() {
                  context
                      .read<EditStudentBloc>()
                      .add(EditStudentDOBChanged(pickedDOB));
                });
              }
            },
      child: Text(
        _formatDate(dob),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}

class _SubmitFloatingActionButton extends StatelessWidget {
  const _SubmitFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<EditStudentBloc, bool>(
        (bloc) => bloc.state.status == EditStudentStatus.loading);

    return FloatingActionButton(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      onPressed: isLoading
          ? null
          : () =>
              context.read<EditStudentBloc>().add(const EditStudentSubmitted()),
      child: isLoading
          ? const CupertinoActivityIndicator()
          : const Icon(Icons.check_rounded),
    );
  }
}
