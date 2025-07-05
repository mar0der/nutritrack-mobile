class Ingredient {
  final String id;
  final String name;
  final String category;
  final Map<String, dynamic>? nutritionalInfo;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
    this.nutritionalInfo,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      nutritionalInfo: json['nutritionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'nutritionalInfo': nutritionalInfo,
    };
  }
}