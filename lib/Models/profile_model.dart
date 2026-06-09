class ProfileModel {
  final int id;
  final String username;
  final String email;
  final String displayName;
  final String nicename;
  final String registered;
  final String firstName;
  final String lastName;
  final String nickname;
  final String bio;
  final String website;
  final String locale;
  final String avatarUrl;
  final String? coverUrl;
  final List<String> roles;
  final List<dynamic> social;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.nicename,
    required this.registered,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.bio,
    required this.website,
    required this.locale,
    required this.avatarUrl,
    this.coverUrl,
    required this.roles,
    required this.social,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'] ?? '',
      nicename: json['nicename'] ?? '',
      registered: json['registered'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      nickname: json['nickname'] ?? '',
      bio: json['bio'] ?? '',
      website: json['website'] ?? '',
      locale: json['locale'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      coverUrl: json['cover_url'],
      roles: List<String>.from(json['roles'] ?? []),
      social: List<dynamic>.from(json['social'] ?? []),
    );
  }
}
