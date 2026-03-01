import 'package:equatable/equatable.dart';
import '../../data/models/user_models.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final UserModel user;
  final String currentLanguage;

  const SettingsLoaded({required this.user, this.currentLanguage = 'ar'});

  SettingsLoaded copyWith({UserModel? user, String? currentLanguage}) {
    return SettingsLoaded(
      user: user ?? this.user,
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }

  @override
  List<Object?> get props => [user, currentLanguage];
}

class SettingsLoggedOut extends SettingsState {
  const SettingsLoggedOut();
}

class SettingsAccountDeleted extends SettingsState {
  const SettingsAccountDeleted();
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
