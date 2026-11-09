import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_type.dart';

class NotificationModel {
  final String id;
  final String recipientUid;
  final String recipientRole;
  final String senderUid;
  final String senderName;
  final String type;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.recipientUid,
    required this.recipientRole,
    required this.senderUid,
    required this.senderName,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    this.data = const {},
    this.isRead = false,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? recipientUid,
    String? recipientRole,
    String? senderUid,
    String? senderName,
    String? type,
    String? titleEn,
    String? titleAr,
    String? bodyEn,
    String? bodyAr,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      recipientUid: recipientUid ?? this.recipientUid,
      recipientRole: recipientRole ?? this.recipientRole,
      senderUid: senderUid ?? this.senderUid,
      senderName: senderName ?? this.senderName,
      type: type ?? this.type,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      bodyEn: bodyEn ?? this.bodyEn,
      bodyAr: bodyAr ?? this.bodyAr,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientUid': recipientUid,
      'recipientRole': recipientRole,
      'senderUid': senderUid,
      'senderName': senderName,
      'type': type,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'bodyEn': bodyEn,
      'bodyAr': bodyAr,
      'data': data,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, {String? id}) {
    DateTime parsedCreatedAt;
    final rawDate = map['createdAt'];
    if (rawDate is Timestamp) {
      parsedCreatedAt = rawDate.toDate();
    } else if (rawDate is String) {
      parsedCreatedAt = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return NotificationModel(
      id: id ?? (map['id'] as String? ?? ''),
      recipientUid: map['recipientUid'] as String? ?? '',
      recipientRole: map['recipientRole'] as String? ?? '',
      senderUid: map['senderUid'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      type: map['type'] as String? ?? '',
      titleEn: map['titleEn'] as String? ?? '',
      titleAr: map['titleAr'] as String? ?? '',
      bodyEn: map['bodyEn'] as String? ?? '',
      bodyAr: map['bodyAr'] as String? ?? '',
      data: Map<String, dynamic>.from(map['data'] as Map? ?? {}),
      isRead: map['isRead'] as bool? ?? false,
      createdAt: parsedCreatedAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json, {String? id}) =>
      NotificationModel.fromMap(json, id: id);

  String localizedTitle(String languageCode) =>
      languageCode == 'ar' ? titleAr : titleEn;

  String localizedBody(String languageCode) =>
      languageCode == 'ar' ? bodyAr : bodyEn;

  bool get isBookingRelated => NotificationType.isBookingRelated(type);
  bool get isAdminRelated => NotificationType.isAdminRelated(type);
}
