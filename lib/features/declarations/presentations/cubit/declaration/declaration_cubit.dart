import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/runtime_data.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/api_result.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../data/models/declaration_model.dart';
import '../../pages/properties_list_in_declaration_page.dart';
import 'declaration_states.dart';

class DeclarationCubit extends Cubit<DeclarationState> {
  DeclarationCubit() : super(DeclarationListInitial());

  List<DeclarationModel>? _declarationList;

  List<DeclarationModel>? get declarationList => _declarationList;

  // BuildContext? _persistentNavContext;

  // void saveNavContext(BuildContext context) {
  //   _persistentNavContext = context;
  // }

  Future<void> fetchList() async {
    emit(DeclarationListLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.declarations,
      );
      return declarationListFromJson(response.data['data']);
    });

    switch (result) {
      case ApiSuccess(:final data):
        _declarationList = data;
        emit(DeclarationListLoaded(data));
      case ApiError(:final message):
        emit(DeclarationListError(message));
    }
  }

  void onDeclarationCardTapped(
    DeclarationModel declarationModel, {
    BuildContext? context,
  }) {
    // final ctx = context ?? _persistentNavContext;
    // if (ctx == null) return;

    // لو بعتلنا context جديد احفظه
    // if (context != null) {
    //   _persistentNavContext = context;
    // }

    PersistentNavBarNavigator.pushNewScreen(
      context ?? RuntimeData.getCurrentContext()!,
      screen: PropertiesListInDeclarationPage(declarationModel, fetchList),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
    );
  }
}
