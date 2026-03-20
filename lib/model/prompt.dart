abstract class Prompt {
  final String id;
  final String message;

  Prompt({required this.id, required this.message});

  factory Prompt.fromMap(Map map) {
    final type = map['type'];
    if (type is! int) throw Exception('type is! int');
    switch (type) {
      case 0:
        return Agent(id: map['id'].toString(), message: map['message']);
      case 1:
        return Client(id: map['id'].toString(), message: map['message']);
      default:
        throw Exception('case Exhaustion');
    }
  }
}

class Agent extends Prompt {
  Agent({required super.id, required super.message});
}

class Client extends Prompt {
  Client({required super.id, required super.message});
}
