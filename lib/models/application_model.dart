class Application {
  final int id;
  final String name;
  bool isSelected;

  Application({required this.id, required this.name, this.isSelected = false});

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      name: json['name'] ?? '',
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_application': id,
    };
  }
}
