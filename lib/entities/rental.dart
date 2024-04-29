import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Rental {
  final String id;
  final String date;
  final double fee;
  final String status;
  final String client_id;
  final String bus_id;
  Rental({
    required this.id,
    required this.date,
    required this.fee,
    required this.status,
    required this.client_id,
    required this.bus_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'fee': fee,
      'status': status,
      'client_id': client_id,
      'bus_id': bus_id,
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
      id: map['id'] as String,
      date: map['date'] as String,
      fee: map['fee'] as double,
      status: map['status'] as String,
      client_id: map['client_id'] as String,
      bus_id: map['bus_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rental.fromJson(String source) =>
      Rental.fromMap(json.decode(source) as Map<String, dynamic>);
}
