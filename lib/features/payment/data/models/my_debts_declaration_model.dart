class MyDebtsDeclarationModel {
  final int id;
  final String declarationNumber;
  final String declarationTypeText;
  final String statusId;
  final String statusText;
  final String creationDate;
  final String? submittionDate;
  final String? updateDate;
  final String submitterType;
  final String taxpayer;
  final int totalUnits;

  const MyDebtsDeclarationModel({
    required this.id,
    required this.declarationNumber,
    required this.declarationTypeText,
    required this.statusId,
    required this.statusText,
    required this.creationDate,
    this.submittionDate,
    this.updateDate,
    required this.submitterType,
    required this.taxpayer,
    required this.totalUnits,
  });

  factory MyDebtsDeclarationModel.fromJson(Map<String, dynamic> json) {
    return MyDebtsDeclarationModel(
      id: json['id'],
      declarationNumber: json['declaration_number'] ?? '',
      declarationTypeText: json['declaration_type_text'] ?? '',
      statusId: json['status_id'].toString(),
      statusText: json['status_text'] ?? '',
      creationDate: json['creation_date'] ?? '',
      submittionDate: json['submittion_date'],
      updateDate: json['update_date'],
      submitterType: json['submitter_type'] ?? '',
      taxpayer: json['taxpayer'] ?? '',
      totalUnits: json['units_count']?['total'] ?? 0,
    );
  }
}
