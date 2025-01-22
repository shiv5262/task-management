class Preferences {
  final bool isDarkMode;
  final String sortOrder;

  Preferences({
    required this.isDarkMode,
    required this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'sortOrder': sortOrder,
    };
  }
}
