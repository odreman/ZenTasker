class Category {
  Category(this.name);

  Category.fromJson(Map<String, dynamic> json) : name = json['name'];

  final String name;

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  static final List<Category> _predefinedCategories = [
    Category('Ninguna categoría'),
    Category('Trabajo'),
    Category('Personal'),
    Category('Lista de deseos'),
    Category('Cumpleaños'),
  ];

  static List<Category> getPredefinedCategories() {
    return _predefinedCategories;
  }
}
