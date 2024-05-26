import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kudosware/core/model/model.dart';

part 'students_overview_event.dart';
part 'students_overview_state.dart';

final class StudentsOverviewBloc
    extends Bloc<StudentsOverviewEvent, StudentsOverviewState> {
  StudentsOverviewBloc(super.initialState);
}
