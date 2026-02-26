import 'package:equatable/equatable.dart';

enum DeclarationStatus { draft, submitted, approved, rejected }

extension DeclarationStatusLabel on DeclarationStatus {
  String get label {
    switch (this) {
      case DeclarationStatus.draft:
        return 'مسودة';
      case DeclarationStatus.submitted:
        return 'مقدم';
      case DeclarationStatus.approved:
        return 'معتمد';
      case DeclarationStatus.rejected:
        return 'مرفوض';
    }
  }
}

class DeclarationSummary extends Equatable {
  final String id;
  final String declarationNumber;
  final String ownerName;
  final DateTime submittedAt;
  final int unitCount;
  final DeclarationStatus status;

  const DeclarationSummary({
    required this.id,
    required this.declarationNumber,
    required this.ownerName,
    required this.submittedAt,
    required this.unitCount,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [id, declarationNumber, ownerName, submittedAt, unitCount, status];
}
