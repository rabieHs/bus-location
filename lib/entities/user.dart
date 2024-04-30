// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String? id;
  String name;
  String lastname;
  String email;
  final String type;

  User({
    required this.type,
    this.id,
    required this.name,
    required this.lastname,
    required this.email,
  });
}
