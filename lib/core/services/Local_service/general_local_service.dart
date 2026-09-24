import 'package:hive_flutter/hive_flutter.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';

class GeneralLocalService {
  Future<Box> _getBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      LoggerService.debug('Opening Hive box: $boxName', tag: 'GeneralLocalService');
      try {
        return await Hive.openBox(boxName);
      } catch (error, stackTrace) {
        LoggerService.error(
          'Failed to open Hive box: $boxName. Resetting box.',
          tag: 'GeneralLocalService',
          error: error,
          stackTrace: stackTrace,
        );
        await Hive.deleteBoxFromDisk(boxName);
        return await Hive.openBox(boxName);
      }
    }
    return Hive.box(boxName);
  }

  Future<int> add<T>(String boxName, T value) async {
    final box = await _getBox(boxName);
    return await box.add(value);
  }

  Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = await _getBox(boxName);
    await box.put(key, value);
  }

  Future<T?> get<T>(String boxName, dynamic key) async {
    final box = await _getBox(boxName);
    final value = box.get(key);
    if (value is T) {
      return value;
    }
    return null;
  }

  Future<void> delete(String boxName, dynamic key) async {
    final box = await _getBox(boxName);
    await box.delete(key);
  }

  Future<List<T>> getAll<T>(String boxName) async {
    final box = await _getBox(boxName);
    return box.values.whereType<T>().toList();
  }

  Future<void> clearBox(String boxName) async {
    final box = await _getBox(boxName);
    await box.clear();
  }

  Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }
}
