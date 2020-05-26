class Todo {
  final int id;
  final int timestamp;
  final String label;
  final String description;

  Todo({
    this.id,
    this.timestamp,
    this.label,
    this.description,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        timestamp = json['timestamp'],
        label = json['label'],
        description = json['description'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "timestamp": timestamp,
      "label": label,
      "description": description,
    };
  }
}
