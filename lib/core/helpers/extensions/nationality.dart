import 'package:reta/core/helpers/app_enum.dart';

extension NationalityExtension on Nationality {
  String get displayText {
    switch (this) {
      case Nationality.egyptian:
        return 'مصري';
      case Nationality.foreign:
        return 'أجنبي';
    }
  }

  int get id {
    switch (this) {
      case Nationality.egyptian:
        return 1;
      case Nationality.foreign:
        return 2;
    }
  }
}

extension NationalityFromString on String {
  Nationality get getNationality {
    switch (this) {
      case 'مصري':
        return Nationality.egyptian;
      case 'أجنبي':
        return Nationality.foreign;
      default:
        return Nationality.egyptian;
    }
  }
}
