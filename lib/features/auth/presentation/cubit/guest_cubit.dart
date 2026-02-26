import 'package:flutter_bloc/flutter_bloc.dart';

class GuestState {
  final int selectedIndex;

  const GuestState({this.selectedIndex = 0});

  GuestState copyWith({int? selectedIndex}) {
    return GuestState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}

class GuestCubit extends Cubit<GuestState> {
  GuestCubit() : super(const GuestState());

  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
