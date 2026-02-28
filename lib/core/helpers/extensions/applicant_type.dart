import '../app_enum.dart';

extension ApplicantTypeLabel on ApplicantType {
  String get label {
    switch (this) {
      case ApplicantType.owner:
        return 'المالك';
      case ApplicantType.sharedOwnership:
        return 'مالك على الشيوع';
      case ApplicantType.beneficiary:
        return 'منتفع';
      case ApplicantType.agent:
        return 'وكيل';
      case ApplicantType.legalRepresentative:
        return 'ممثل قانوني';
      case ApplicantType.other:
        return 'أخرى';
    }
  }

  int get id {
    switch (this) {
      case ApplicantType.owner:
        return 1;
      case ApplicantType.sharedOwnership:
        return 2;
      case ApplicantType.beneficiary:
        return 3;
      case ApplicantType.agent:
        return 5;
      case ApplicantType.legalRepresentative:
        return 6;
      case ApplicantType.other:
        return 7;
    }
  }
}

extension ApplicantFromInt on String {
  ApplicantType get displayApplicant {
    switch (this) {
      case '1':
        return ApplicantType.owner;
      case '2':
        return ApplicantType.sharedOwnership;
      case '3':
        return ApplicantType.beneficiary;
      case '5':
        return ApplicantType.agent;
      case '6':
        return ApplicantType.legalRepresentative;
      case '7':
        return ApplicantType.other;
      default:
        return ApplicantType.owner;
    }
  }
}
