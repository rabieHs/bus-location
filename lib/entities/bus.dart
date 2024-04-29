// ignore_for_file: public_member_api_docs, sort_constructors_first
class Bus {
  List<dynamic>? images;
  String status;
  final String id;
  String? driver_id;
  final double fee;
  final String type;
  final String energy;
  final String description;
  Bus({
    this.images,
    this.status = "for rent",
    this.driver_id,
    required this.description,
    required this.id,
    required this.fee,
    required this.type,
    required this.energy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'images': images,
      'driver_id': driver_id,
      'id': id,
      'fee': fee,
      'type': type,
      'energy': energy,
      'description': description,
      'status': status,
    };
  }

  factory Bus.fromMap(Map<String, dynamic> map) {
    return Bus(
        images: map["images"] ?? [],
        driver_id: map["driver_id"],
        description: map["description"],
        id: map['id'] as String,
        fee: map['fee'] as double,
        type: map['type'] as String,
        energy: map['energy'] as String,
        status: map['status'] ?? "waiting for rent");
  }
}
