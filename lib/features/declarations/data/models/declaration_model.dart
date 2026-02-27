List<DeclarationModel> declarationListFromJson(dynamic json) {
  if (json is List) {
    return json.map((e) => DeclarationModel.fromJson(e)).toList();
  }
  return [];
}

class DeclarationModel {
  final int? id;
  final String? declarationNumber;
  final String? declarationTypeId;
  final String? declarationTypeText;
  final String? statusId;
  final String? statusText;
  final String? creationDate;
  final String? submittionDate;
  final String? updateDate;
  final String? submitterType;
  final String? taxpayer;

  DeclarationModel({
    this.id,
    this.declarationNumber,
    this.declarationTypeId,
    this.declarationTypeText,
    this.statusId,
    this.statusText,
    this.creationDate,
    this.submittionDate,
    this.updateDate,
    this.submitterType,
    this.taxpayer,
  });

  factory DeclarationModel.fromJson(Map<String, dynamic> json) {
    return DeclarationModel(
      id: json['id'],
      declarationNumber: json['declaration_number'] ?? '',
      declarationTypeId: json['declaration_type_id'] ?? '',
      declarationTypeText: json['declaration_type_text'] ?? '',
      statusId: json['status_id'] ?? '',
      statusText: json['status_text'] ?? '',
      creationDate: json['creation_date'] ?? '',
      submittionDate: json['submittion_date'],
      updateDate: json['update_date'],
      submitterType: json['submitter_type'] ?? '',
      taxpayer: json['taxpayer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'declaration_number': declarationNumber,
      'declaration_type_id': declarationTypeId,
      'declaration_type_text': declarationTypeText,
      'status_id': statusId,
      'status_text': statusText,
      'creation_date': creationDate,
      'submittion_date': submittionDate,
      'update_date': updateDate,
      'submitter_type': submitterType,
      'taxpayer': taxpayer,
    };
  }
}
