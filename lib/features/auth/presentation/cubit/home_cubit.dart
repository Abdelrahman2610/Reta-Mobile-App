import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final String? errorMessage;
  final bool showVerificationPrompt;

  const HomeState({
    this.selectedIndex = 0,
    this.errorMessage,
    this.showVerificationPrompt = false,
  });

  HomeState copyWith({
    int? selectedIndex,
    String? errorMessage,
    bool? showVerificationPrompt,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      errorMessage: errorMessage,
      showVerificationPrompt:
          showVerificationPrompt ?? this.showVerificationPrompt,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    errorMessage,
    showVerificationPrompt,
  ];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  PersistentTabController mainScreenTabController = PersistentTabController();

  static const _protectedTabs = {1, 2, 3};

  void selectTab(int index, {bool isVerified = true}) {
    if (!isVerified && _protectedTabs.contains(index)) {
      emit(state.copyWith(showVerificationPrompt: true));
      return;
    }
    navigateTo(index);
  }

  void jumpTo(int index, {bool isVerified = true}) {
    if (!isVerified && _protectedTabs.contains(index)) {
      emit(state.copyWith(showVerificationPrompt: true));
      return;
    }
    navigateTo(index);
  }

  void dismissVerificationPrompt() {
    emit(state.copyWith(showVerificationPrompt: false));
  }

  void navigateTo(int index) {
    mainScreenTabController.jumpToTab(index);
    emit(state.copyWith(selectedIndex: index, showVerificationPrompt: false));
  }

  @override
  Future<void> close() {
    mainScreenTabController.dispose();
    return super.close();
  }
}
