import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeTabChanged>(_onTabChanged);
  }

  void _onTabChanged(
    HomeTabChanged event,
    Emitter<HomeState> emit,
  ) {
    print(event.tabIndex);
    emit(state.copyWith(activeIndex: event.tabIndex));
  }
}
