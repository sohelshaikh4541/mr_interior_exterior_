class Profile {
  final String name;
  final String imageUrl;
  final List<String> followers;

  Profile({required this.name, required this.imageUrl, required this.followers});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      imageUrl: json['imageUrl'],
      followers: List<String>.from(json['followers']),
    );
  }
}
