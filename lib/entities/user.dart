// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String type;

  User({
    required this.type,
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
  });
}
