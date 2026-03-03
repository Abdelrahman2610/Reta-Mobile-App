import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final String? errorMessage;

  const HomeState({this.selectedIndex = 0, this.errorMessage});

  HomeState copyWith({int? selectedIndex, String? errorMessage}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, errorMessage];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
  PersistentTabController mainScreenTabController = PersistentTabController();

  void selectTab(int index) {
    mainScreenTabController.jumpToTab(index);
    emit(state.copyWith(selectedIndex: index));
  }

  void jumpTo(int index) {
    mainScreenTabController.jumpToTab(index);
    emit(state.copyWith(selectedIndex: index));
  }

  @override
  Future<void> close() {
    mainScreenTabController.dispose();
    return super.close();
  }
}
