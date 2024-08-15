class User {
  final String username;
  final DateTime registrationDate;

  User({required this.username, required this.registrationDate});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'date_enregistrement_utilisateur': registrationDate.toIso8601String(),
    };
  }
}
