class DebtsFilterData {
  final String? declarationNumber;
  final String? declarationType;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final dynamic statusId;

  const DebtsFilterData({
    this.declarationNumber,
    this.declarationType,
    this.dateFrom,
    this.dateTo,
    this.statusId = 'all',
  });

  int get activeCount {
    int count = 0;
    if (declarationNumber?.isNotEmpty == true) count++;
    if (declarationType != null && declarationType != 'all') count++;
    if (dateFrom != null || dateTo != null) count++;
    if (statusId.toString() != 'all') count++;
    return count;
  }

  DebtsFilterData copyWith({
    String? declarationNumber,
    String? declarationType,
    DateTime? dateFrom,
    DateTime? dateTo,
    dynamic statusId,
    bool clearNumber = false,
    bool clearType = false,
    bool clearDates = false,
  }) {
    return DebtsFilterData(
      declarationNumber: clearNumber
          ? null
          : (declarationNumber ?? this.declarationNumber),
      declarationType: clearType
          ? null
          : (declarationType ?? this.declarationType),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
      statusId: statusId ?? this.statusId,
    );
  }
}
