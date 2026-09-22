import 'package:hive_flutter/hive_flutter.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';

class GeneralLocalService {
  Future<Box<T>> _getBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      LoggerService.debug('Opening Hive box: $boxName', tag: 'GeneralLocalService');
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  Future<int> add<T>(String boxName, T value) async {
    final box = await _getBox<T>(boxName);
    return await box.add(value);
  }

  Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = await _getBox<T>(boxName);
    await box.put(key, value);
  }

  Future<T?> get<T>(String boxName, dynamic key) async {
    final box = await _getBox<T>(boxName);
    return box.get(key);
  }

  Future<void> delete<T>(String boxName, dynamic key) async {
    final box = await _getBox<T>(boxName);
    await box.delete(key);
  }

  Future<List<T>> getAll<T>(String boxName) async {
    final box = await _getBox<T>(boxName);
    return box.values.toList();
  }

  Future<void> clearBox<T>(String boxName) async {
    final box = await _getBox<T>(boxName);
    await box.clear();
  }

  Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }
}
