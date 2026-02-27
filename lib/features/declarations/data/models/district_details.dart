import 'package:reta/features/declarations/data/models/declarations_lookups.dart';
import 'package:reta/features/declarations/data/models/street_model.dart';

class DistrictDetailsModel {
  final List<DeclarationLookup> villages;
  final List<StreetModel> streets;
  DistrictDetailsModel({required this.villages, required this.streets});

  factory DistrictDetailsModel.fromJson(Map<String, dynamic> json) {
    return DistrictDetailsModel(
      villages: (json['villages'] as List)
          .map((e) => DeclarationLookup.fromJson(e))
          .toList(),
      streets: (json['streets'] as List)
          .map((e) => StreetModel.fromJson(e))
          .toList(),
    );
  }
}
