import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/declaration_summary.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<DeclarationSummary> declarations;
  final bool isLoadingDeclarations;
  final String? errorMessage;

  const HomeState({
    this.selectedIndex = 0,
    this.declarations = const [],
    this.isLoadingDeclarations = false,
    this.errorMessage,
  });

  HomeState copyWith({
    int? selectedIndex,
    List<DeclarationSummary>? declarations,
    bool? isLoadingDeclarations,
    String? errorMessage,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      declarations: declarations ?? this.declarations,
      isLoadingDeclarations:
          isLoadingDeclarations ?? this.isLoadingDeclarations,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    declarations,
    isLoadingDeclarations,
    errorMessage,
  ];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState()) {
    _loadDeclarations();
  }

  void selectTab(int index) => emit(state.copyWith(selectedIndex: index));

  Future<void> refreshDeclarations() => _loadDeclarations();

  Future<void> _loadDeclarations() async {
    emit(state.copyWith(isLoadingDeclarations: true, errorMessage: null));
    try {
      // TODO: Replace with real repository call
      await Future.delayed(const Duration(milliseconds: 600));
      // final results = <DeclarationSummary>[];
      final results = [
        DeclarationSummary(
          id: '1',
          declarationNumber: '2165484948',
          ownerName: 'مالك على السريع',
          submittedAt: DateTime(2026, 1, 8),
          unitCount: 2,
          status: DeclarationStatus.draft,
        ),
        DeclarationSummary(
          id: '2',
          declarationNumber: '2165484948',
          ownerName: 'مالك على السريع',
          submittedAt: DateTime(2026, 4, 12),
          unitCount: 2,
          status: DeclarationStatus.approved,
        ),
      ];
      emit(state.copyWith(declarations: results, isLoadingDeclarations: false));
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingDeclarations: false,
          errorMessage: 'فشل في تحميل الإقرارات',
        ),
      );
    }
  }
}
