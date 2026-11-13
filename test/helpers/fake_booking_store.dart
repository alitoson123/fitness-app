import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/repos/booking_actions/booking_actions_repo.dart';
import 'package:fitness_app/features/notifications/data/helpers/notification_dispatcher.dart';

/// In-memory Firestore for booking tests. Only what the booking code uses.
class FakeBookingStore implements FirestoreService {
  final Map<String, Map<String, dynamic>> docs = {};
  int writeCount = 0;

  void put(BookingModel b) => docs[b.id] = b.toMap();

  BookingModel booking(String id) => BookingModel.fromJson(docs[id]!, id: id);

  void _apply(Map<String, dynamic> target, Map<String, dynamic> update) {
    update.forEach((key, value) {
      if (value is FieldValue) {
        if (value == FieldValue.delete()) {
          target.remove(key);
        } else {
          target[key] = Timestamp.now(); // serverTimestamp
        }
      } else {
        target[key] = value;
      }
    });
  }

  @override
  Future<Map<String, dynamic>?> transactUpdate({
    required String collection,
    required String docId,
    required Map<String, dynamic> Function(Map<String, dynamic>? current)
        buildUpdate,
  }) async {
    final current = docs[docId];
    final snapshot = current == null ? null : Map<String, dynamic>.from(current);
    final update = buildUpdate(snapshot);
    _apply(docs[docId]!, update);
    writeCount++;
    return snapshot;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// One notification the repo asked to send.
class SentNotification {
  final String method;
  final Map<Symbol, dynamic> args;
  SentNotification(this.method, this.args);

  dynamic operator [](String name) => args[Symbol(name)];
}

class _RecordingDispatcher implements NotificationDispatcher {
  final List<SentNotification> sent;
  _RecordingDispatcher(this.sent);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName.toString(); // Symbol("dispatchX")
    sent.add(SentNotification(
      name.substring(8, name.length - 2),
      invocation.namedArguments,
    ));
    return Future<void>.value();
  }
}

/// A [BookingActionsRepo] on [store], acting as [uid], at time [now].
({BookingActionsRepo repo, List<SentNotification> sent}) makeActionsRepo(
  FakeBookingStore store, {
  required String? Function() uid,
  DateTime? now,
}) {
  final sent = <SentNotification>[];
  final dispatcher = _RecordingDispatcher(sent);
  final repo = BookingActionsRepo(
    firestoreService: store,
    currentUid: uid,
    clock: () => now ?? DateTime(2030, 1, 1),
    notify: (action) => action(dispatcher),
  );
  return (repo: repo, sent: sent);
}
