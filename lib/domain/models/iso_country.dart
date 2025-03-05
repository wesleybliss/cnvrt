
class ISOCountry {
  final String code;
  final String name;
  final String emoji;
  
  ISOCountry({
    required this.code,
    required this.name,
    required this.emoji,
  });

  factory ISOCountry.fromJson(Map<String, dynamic> json) {
    return ISOCountry(
      code: json['code'],
      name: json['name'],
      emoji: json['emoji'],
    );
  }
}
