class CoachSetupCertHelper {
  static List<String> add(List<String> current, String url) {
    return List<String>.from(current)..add(url);
  }

  static List<String> update(List<String> current, int index, String url) {
    if (index >= 0 && index < current.length) {
      final list = List<String>.from(current);
      list[index] = url;
      return list;
    }
    return current;
  }

  static List<String> remove(List<String> current, int index) {
    if (index >= 0 && index < current.length) {
      final list = List<String>.from(current)..removeAt(index);
      return (list.length == 1 && list.first.isEmpty) ? [] : list;
    }
    return current;
  }
}

