// lib/features/payment/data/models/payment_filter.dart

class PaymentFilterData {
  final String? procedureNumber;
  final String? claimNumber;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final dynamic statusId; // "all" or int

  const PaymentFilterData({
    this.procedureNumber,
    this.claimNumber,
    this.dateFrom,
    this.dateTo,
    this.statusId = 'all',
  });

  int get activeCount {
    int count = 0;
    if (procedureNumber?.isNotEmpty == true) count++;
    if (claimNumber?.isNotEmpty == true) count++;
    if (dateFrom != null || dateTo != null) count++;
    if (statusId.toString() != 'all') count++;
    return count;
  }

  PaymentFilterData copyWith({
    String? procedureNumber,
    String? claimNumber,
    DateTime? dateFrom,
    DateTime? dateTo,
    dynamic statusId,
    bool clearProcedure = false,
    bool clearClaim = false,
    bool clearDates = false,
  }) {
    return PaymentFilterData(
      procedureNumber: clearProcedure
          ? null
          : (procedureNumber ?? this.procedureNumber),
      claimNumber: clearClaim ? null : (claimNumber ?? this.claimNumber),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
      statusId: statusId ?? this.statusId,
    );
  }
}
