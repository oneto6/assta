class Suggestion {
  final String id;
  final String title;
  final String description;

  const Suggestion(this.id, this.title, this.description);

  factory Suggestion.fromMap(Map data) {
    return Suggestion(
      data['id'].toString(),
      data['title'],
      data['description'],
    );
  }
}
