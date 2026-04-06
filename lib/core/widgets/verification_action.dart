import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/presentation/cubit/home_cubit.dart';

class VerificationAction {
  final Function? onLater;
  final Function? onVerifyNow;

  const VerificationAction({this.onLater, this.onVerifyNow});

  factory VerificationAction.resolve(UserModel user, BuildContext context) {
    final bool phoneVerified = user.phoneVerified ?? false;
    final bool ocrVerified = user.nationalIdVerified ?? false;

    if (!phoneVerified || !ocrVerified) {
      return VerificationAction(
        onLater: () => context.read<HomeCubit>().navigateTo(0),
        onVerifyNow: () => context.read<HomeCubit>().navigateTo(4),
      );
    }

    return VerificationAction(
      onLater: null,
      onVerifyNow: () => context.read<HomeCubit>().navigateTo(4),
    );
  }
}
