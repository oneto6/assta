class Session {
  final String id;
  final String name;

  Session({required this.id, required this.name});

  factory Session.fromMap(Map map) {
    return Session(id: map['id'].toString(), name: map['name']);
  }
}
