import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/app/app.dart';
import 'package:kudosware/feature/edit_student/edit_student.dart';
import 'package:kudosware/feature/home/bloc/home_bloc.dart';
import 'package:kudosware/feature/students_overview/view/students_overview_page.dart';
import 'package:kudosware/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (prev, curr) => prev.user != curr.user,
      listener: (context, state) {
        if (!state.user.isEmailVerified) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.amber,
                content: const Text(
                    'A verification email has been sent to your email.'),
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .hideCurrentMaterialBanner(),
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            );
        }
      },
      child: const Scaffold(
        body: _HomeViewBody(),
        bottomNavigationBar: _BottomNavigationBar(),
      ),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, int>(
      selector: (state) => state.activeIndex,
      builder: (context, index) {
        return IndexedStack(
          index: index,
          children: const [
            KeepAlivePage(
              child: StudentsOverviewPage(),
            ),
            KeepAlivePage(
              child: EditStudentPage(),
            ),
          ],
        );
      },
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final activeIndex =
        context.select<HomeBloc, int>((bloc) => bloc.state.activeIndex);

    return NavigationBar(
      selectedIndex: activeIndex,
      onDestinationSelected: (destIndex) {
        context.read<HomeBloc>().add(HomeTabChanged(destIndex));
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Students',
          tooltip: 'Student List',
        ),
        NavigationDestination(
          icon: Icon(Icons.dynamic_form_outlined),
          label: 'Add Student',
          tooltip: 'Add Student Form',
        ),
      ],
    );
  }
}
