import '../../data/models/declarations_lookups.dart';

abstract class DeclarationLookupsState {}

class DeclarationLookupsInitial extends DeclarationLookupsState {}

class DeclarationLookupsLoading extends DeclarationLookupsState {}

class DeclarationLookupsLoaded extends DeclarationLookupsState {
  final DeclarationLookupsModel lookups;
  DeclarationLookupsLoaded(this.lookups);
}

class DeclarationLookupsError extends DeclarationLookupsState {
  final String message;
  DeclarationLookupsError(this.message);
}
