import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/dio_client.dart';

import '../../../../../../core/network/api_result.dart';
import '../../../data/models/payment_lookups.dart';
import 'claim_status_lookup_state.dart';

class ClaimStatusLookupCubit extends Cubit<ClaimStatusLookupState> {
  ClaimStatusLookupCubit() : super(ClaimStatusLookupInitial());

  Future<void> fetchClaimStatuses() async {
    emit(ClaimStatusLookupLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.claimStatus,
      );
      final list = response.data['data']['status'] as List;
      return list.map((e) => PaymentStatusLookup.fromJson(e)).toList();
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(ClaimStatusLookupSuccess(data));
      case ApiError(:final message):
        emit(ClaimStatusLookupError(message));
    }
  }
}
