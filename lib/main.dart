import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/app/app.dart';
import 'package:kudosware/bloc_observer.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/core/service/service.dart';
import 'package:kudosware/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = const AppBlocObserver();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(
              service: FirebaseAuthenticationService(
            firebaseAuth: FirebaseAuth.instance,
          )),
        ),
        RepositoryProvider<StudentRepository>(
          create: (context) => StudentRepository(
            service: FirestoreStudentService(
              firestore: FirebaseFirestore.instance,
            ),
          ),
        ),
      ],
      child: const KudoswareApp(),
    ),
  );
}
