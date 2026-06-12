class SocialMedia {
  final String platformName;
  final String link;

  const SocialMedia({required this.platformName, required this.link});

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      platformName: json['platform_name'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }
}
