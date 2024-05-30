part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeTabChanged extends HomeEvent {
  const HomeTabChanged(this.tabIndex);

  final int tabIndex;

  @override
  List<Object> get props => [tabIndex];
}

