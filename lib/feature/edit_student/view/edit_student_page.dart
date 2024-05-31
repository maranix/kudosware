import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/enums.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/core/utils/validators.dart';
import 'package:kudosware/feature/edit_student/bloc/edit_student_bloc.dart';
import 'package:kudosware/widgets/widgets.dart';

class EditStudentPage extends StatelessWidget {
  const EditStudentPage({super.key, this.student});

  final StudentEntry? student;

  static MaterialPageRoute<void> route({StudentEntry? student}) {
    return MaterialPageRoute(
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
    return BlocListener<EditStudentBloc, EditStudentState>(
      listenWhen: (prev, curr) {
        return prev.status != curr.status;
      },
      listener: (context, state) {
        void onSuccess() {
          if (state.isEditing) {
            Navigator.of(context).pop();
          }
        }

        return switch (state.status) {
          EditStudentStatus.failure => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            ),
          EditStudentStatus.success => onSuccess(),
          _ => null,
        };
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.read<EditStudentBloc>().state.isEditing
                ? 'Edit Student'
                : 'Add Student',
          ),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _EditStudentForm(),
          ),
        ),
      ),
    );
  }
}

class _EditStudentForm extends StatefulWidget {
  const _EditStudentForm();

  @override
  State<_EditStudentForm> createState() => _EditStudentFormState();
}

class _EditStudentFormState extends State<_EditStudentForm> {
  late final GlobalKey<FormState> _formKey;

  void _onValidated() {
    if (_formKey.currentState == null) return;

    if (_formKey.currentState!.validate()) {
      context.read<EditStudentBloc>().add(const EditStudentSubmitted());
    }
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const _FirstNameField(),
          const _LastNameField(),
          const Row(
            children: [
              Expanded(child: _GenderField()),
              SizedBox(width: 8),
              Expanded(child: _DOBPicker()),
            ],
          ),
          _AddStudentButton(onValidated: _onValidated),
        ]
            .map((child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: child,
                ))
            .toList(),
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
      decoration: textFieldDecoration(
        enabled: isEnabled,
        labelText: 'First Name',
        hintText: 'John',
      ),
      onChanged: (value) {
        context.read<EditStudentBloc>().add(EditStudentFirstNameChanged(value));
      },
      validator: validateFirstName,
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
      decoration: textFieldDecoration(
        enabled: isEnabled,
        labelText: 'Last Name',
        hintText: 'Doe',
      ),
      onChanged: (value) {
        context.read<EditStudentBloc>().add(EditStudentLastNameChanged(value));
      },
      validator: validateLastName,
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
      decoration: textFieldDecoration(
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
      keyboardType: TextInputType.datetime,
      decoration: textFieldDecoration(
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

class _AddStudentButton extends StatelessWidget {
  const _AddStudentButton({
    required this.onValidated,
  });

  final VoidCallback onValidated;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EditStudentBloc, EditStudentState, bool>(
      selector: (state) => state.status == EditStudentStatus.loading,
      builder: (context, isLoading) {
        return FilledButton(
          onPressed: isLoading ? null : onValidated,
          child: isLoading
              ? const CupertinoActivityIndicator()
              : const Text('Add Student'),
        );
      },
    );
  }
}
