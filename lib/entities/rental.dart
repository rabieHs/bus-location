import 'dart:convert';

import 'package:bus_location/entities/location.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Rental {
  final String id;
  final String date;
  final double fee;
  final String status;
  final String client_id;
  final String bus_id;
  final Location start;
  final Location destination;
  final int totalPrice;
  Rental({
    required this.id,
    required this.date,
    required this.fee,
    required this.status,
    required this.client_id,
    required this.bus_id,
    required this.start,
    required this.destination,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'fee': fee,
      'status': status,
      'client_id': client_id,
      'bus_id': bus_id,
      'start': start.toMap(),
      'destination': destination.toMap(),
      'totalPrice': totalPrice,
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
      start: Location.fromMap(map['start'] as Map<String, dynamic>),
      destination: Location.fromMap(map['destination'] as Map<String, dynamic>),
      totalPrice: map['totalPrice'] as int,
    );
  }
}
