import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/enums.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/feature/edit_student/bloc/edit_student_bloc.dart';

class EditStudentPage extends StatelessWidget {
  const EditStudentPage({super.key, this.student});

  final Student? student;

  static Route<void> route({Student? student}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EditStudentPage(student: student),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditStudentBloc(
        repo: context.read<StudentRepository>(),
        student: student,
      ),
      child: const _EditStudentView(),
    );
  }
}

class _EditStudentView extends StatelessWidget {
  const _EditStudentView();

  @override
  Widget build(BuildContext context) {
    final isEditing = context.read<EditStudentBloc>().state.isEditing;

    return BlocListener<EditStudentBloc, EditStudentState>(
      listenWhen: (prev, curr) {
        return prev.status != curr.status;
      },
      listener: (context, state) {
        return switch (state.status) {
          EditStudentStatus.failure => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            ),
          EditStudentStatus.success => Navigator.of(context).pop(),
          _ => null,
        };
      },
      child: Scaffold(
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
      ),
    );
  }
}

class _FirstNameField extends StatelessWidget {
  const _FirstNameField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context.select<EditStudentBloc, bool>(
        (bloc) => bloc.state.status != EditStudentStatus.loading);
    final initialValue = context.read<EditStudentBloc>().state.firstName;

    return TextFormField(
      key: const Key('editStudentView_firstName_textFormField'),
      initialValue: initialValue,
      decoration: InputDecoration(
        enabled: isEnabled,
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
    final isEnabled = context.select<EditStudentBloc, bool>(
        (bloc) => bloc.state.status != EditStudentStatus.loading);
    final initialValue = context.read<EditStudentBloc>().state.lastName;

    return TextFormField(
      key: const Key('editStudentView_lastName_textFormField'),
      initialValue: initialValue,
      decoration: InputDecoration(
        enabled: isEnabled,
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
    final isEnabled = context.select<EditStudentBloc, bool>(
        (bloc) => bloc.state.status != EditStudentStatus.loading);
    final initialValue = context.read<EditStudentBloc>().state.gender;

    return DropdownButtonFormField(
      key: const Key('editStudentView_gender_textFormField'),
      value: initialValue.isEmpty ? 'other' : initialValue,
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Gender',
        hintText: 'Other',
      ),
      items: GenderEnum.values.map((g) {
        return DropdownMenuItem<String>(
          value: g.name,
          child: Text(g.name.replaceFirst(g.name[0], g.name[0].toUpperCase())),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;
        context.read<EditStudentBloc>().add(EditStudentGenderChanged(value));
      },
    );
  }
}

class _DOBPicker extends StatefulWidget {
  const _DOBPicker();

  @override
  State<_DOBPicker> createState() => _DOBPickerState();
}

class _DOBPickerState extends State<_DOBPicker> {
  late TextEditingController _controller;

  void _updateControllerText(DateTime date) {
    _controller.text = _formatDate(date);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = context.select<EditStudentBloc, bool>(
        (bloc) => bloc.state.status != EditStudentStatus.loading);
    final dob =
        context.select<EditStudentBloc, DateTime>((bloc) => bloc.state.dob);
    _updateControllerText(dob);

    return TextFormField(
      key: const Key('editStudentView_lastName_textFormField'),
      controller: _controller,
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Date of Birth',
        hintText: '01/01/1900',
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        final pickedDOB = await showDatePicker(
          context: context,
          initialDate: dob,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDOB != null && context.mounted) {
          context.read<EditStudentBloc>().add(EditStudentDOBChanged(pickedDOB));
        }
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
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
