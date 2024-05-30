part of 'home_bloc.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.activeIndex = 0,
  });

  final int activeIndex;

  HomeState copyWith({
    int? activeIndex,
  }) {
    return HomeState(
      activeIndex: activeIndex ?? this.activeIndex,
    );
  }

  @override
  List<Object> get props => [activeIndex];
}
