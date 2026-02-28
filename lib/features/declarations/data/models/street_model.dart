class StreetModel {
  final int id;
  final int villageId;
  final String name;

  StreetModel({required this.id, required this.villageId, required this.name});

  factory StreetModel.fromJson(Map<String, dynamic> json) => StreetModel(
    id: json['id'] as int,
    villageId: int.tryParse(json['village_id']?.toString() ?? '0') ?? 0,
    name: json['name'] as String,
  );
}
