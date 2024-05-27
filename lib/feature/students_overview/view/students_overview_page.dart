import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/feature/students_overview/bloc/students_overview_bloc.dart';

class StudentsOverviewPage extends StatelessWidget {
  const StudentsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<StudentRepository>();

    return BlocProvider(
      create: (context) => StudentsOverviewBloc(repo: repo)
        ..add(
          const StudentsOverviewFetchRequested(),
        ),
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
      ),
      body: BlocConsumer<StudentsOverviewBloc, StudentsOverviewState>(
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: state.studentIds.length,
              itemBuilder: (context, index) {
                final student = state.studentMap[ids.elementAt(index)];
                if (student == null) return const SizedBox.shrink();

                return Text("${student.firstName} ${student.lastName}");
              },
            ),
          );
        },
      ),
    );
  }
}
