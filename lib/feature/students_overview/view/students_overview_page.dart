import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/feature/edit_student/edit_student.dart';
import 'package:kudosware/feature/students_overview/bloc/students_overview_bloc.dart';
import 'package:kudosware/widgets/email_not_verified_banner.dart';
import 'package:kudosware/widgets/widgets.dart';

class StudentsOverviewPage extends StatelessWidget {
  const StudentsOverviewPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (context) => const StudentsOverviewPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<StudentRepository>();

    return BlocProvider(
      create: (context) => StudentsOverviewBloc(repo: repo)
        ..add(const StudentsOverviewFetchRequested()),
      child: const _StudentsOverviewView(),
    );
  }
}

class _StudentsOverviewView extends StatelessWidget {
  const _StudentsOverviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kudosware'),
        actions: const [
          AppBarLogoutButton(),
        ],
      ),
      body: EmailNotVerifiedBanner(
        child: BlocConsumer<StudentsOverviewBloc, StudentsOverviewState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == StudentsOverviewStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state.studentIds.isEmpty) {
              if (state.status == StudentsOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != StudentsOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'No students found',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            final ids = state.studentIds;
            return ListView.builder(
              itemCount: state.studentIds.length,
              itemBuilder: (context, index) {
                final id = ids.elementAt(index);
                final student = state.studentMap[id];
                if (student == null) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    key: ObjectKey(student),
                    title: Text(student.fullName,
                        style: Theme.of(context).textTheme.titleMedium!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _EditStudentButton(student),
                        _DeleteStudentButton(student.id),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(student.gender.value),
                        Text(student.dobString),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EditStudentButton extends StatelessWidget {
  const _EditStudentButton(this.student);

  final StudentEntry student;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      color: Theme.of(context).iconTheme.color,
      onPressed: () =>
          Navigator.of(context).push(EditStudentPage.route(student: student)),
      icon: const Icon(Icons.edit),
    );
  }
}

class _DeleteStudentButton extends StatelessWidget {
  const _DeleteStudentButton(this.id);

  final String id;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      color: Colors.red,
      onPressed: () async {
        final deletionConfirmed = await showAdaptiveDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: const Text('Deleting Student'),
                content: const Text(
                    'Are you sure that you want to complete this operation?'),
                actions: [
                  FilledButton.tonal(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ],
              );
            });
        if (deletionConfirmed == null || !deletionConfirmed) return;

        if (deletionConfirmed && context.mounted) {
          context
              .read<StudentsOverviewBloc>()
              .add(StudentsOverviewStudentDeletionRequested(id));
        }
      },
      icon: const Icon(Icons.delete),
    );
  }
}
