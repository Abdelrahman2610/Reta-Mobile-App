import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_result.dart';
import '/features/declarations/data/repositories/declarations_repository.dart';

class HomeState {
  final bool isLoading;
  final String? userName;
  final int pendingDeclarationsCount;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.userName,
    this.pendingDeclarationsCount = 0,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    String? Function()? userName,
    int? pendingDeclarationsCount,
    String? Function()? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName != null ? userName() : this.userName,
      pendingDeclarationsCount:
          pendingDeclarationsCount ?? this.pendingDeclarationsCount,
      error: error != null ? error() : this.error,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  final DeclarationsRepository _declarationsRepository;

  HomeCubit({DeclarationsRepository? declarationsRepository})
    : _declarationsRepository =
          declarationsRepository ?? DeclarationsRepository(),
      super(const HomeState()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, error: () => null));

    final result = await _declarationsRepository.getDeclarations();

    switch (result) {
      case ApiSuccess(:final data):
        final declarations = data['data'] as List? ?? [];
        String? name;
        if (declarations.isNotEmpty) {
          final taxpayer = declarations.first['taxpayer'] as Map?;
          final first = taxpayer?['first_name']?.toString() ?? '';
          final last = taxpayer?['last_name']?.toString() ?? '';
          if (first.isNotEmpty) name = '$first $last'.trim();
        }
        final pending = declarations
            .where((d) => (d['status'] as int? ?? 0) < 3)
            .length;
        emit(
          state.copyWith(
            isLoading: false,
            userName: () => name,
            pendingDeclarationsCount: pending,
          ),
        );
      case ApiError(:final message):
        emit(state.copyWith(isLoading: false, error: () => message));
    }
  }
}
