import '../app_enum.dart';

extension ApplicantTypeLabel on ApplicantType {
  String get label {
    switch (this) {
      case ApplicantType.owner:
        return 'مالك';
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
}
