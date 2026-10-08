import 'package:cloud_firestore/cloud_firestore.dart';

class CoachApplicationModel {
  final String coachUid;
  final String status; // 'pending' | 'approved' | 'rejected'
  final String identityDocumentUrl;
  final List<String> certificateUrls;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final DateTime? resubmittedAt;
  final DateTime? updatedAt;

  const CoachApplicationModel({
    required this.coachUid,
    this.status = 'pending',
    required this.identityDocumentUrl,
    this.certificateUrls = const [],
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    this.resubmittedAt,
    this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  factory CoachApplicationModel.fromJson(Map<String, dynamic> json,) {
    return CoachApplicationModel(
      coachUid: json['coachUid'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      identityDocumentUrl: json['identityDocumentUrl'] as String? ?? '',
      certificateUrls: (json['certificateUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] != null
          ? (json['submittedAt'] is Timestamp
              ? (json['submittedAt'] as Timestamp).toDate()
              : (json['submittedAt'] is String
                  ? DateTime.tryParse(json['submittedAt'] as String)
                  : null))
          : null,
      reviewedAt: json['reviewedAt'] != null
          ? (json['reviewedAt'] is Timestamp
              ? (json['reviewedAt'] as Timestamp).toDate()
              : (json['reviewedAt'] is String
                  ? DateTime.tryParse(json['reviewedAt'] as String)
                  : null))
          : null,
      resubmittedAt: json['resubmittedAt'] != null
          ? (json['resubmittedAt'] is Timestamp
              ? (json['resubmittedAt'] as Timestamp).toDate()
              : (json['resubmittedAt'] is String
                  ? DateTime.tryParse(json['resubmittedAt'] as String)
                  : null))
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : (json['updatedAt'] is String
                  ? DateTime.tryParse(json['updatedAt'] as String)
                  : null))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coachUid': coachUid,
      'status': status,
      'identityDocumentUrl': identityDocumentUrl,
      'certificateUrls': certificateUrls,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (submittedAt != null) 'submittedAt': submittedAt!.toIso8601String(),
      if (reviewedAt != null) 'reviewedAt': reviewedAt!.toIso8601String(),
      if (resubmittedAt != null)
        'resubmittedAt': resubmittedAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  CoachApplicationModel copyWith({
    String? coachUid,
    String? status,
    String? identityDocumentUrl,
    List<String>? certificateUrls,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    DateTime? resubmittedAt,
    DateTime? updatedAt,
  }) {
    return CoachApplicationModel(
      coachUid: coachUid ?? this.coachUid,
      status: status ?? this.status,
      identityDocumentUrl: identityDocumentUrl ?? this.identityDocumentUrl,
      certificateUrls: certificateUrls ?? this.certificateUrls,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      resubmittedAt: resubmittedAt ?? this.resubmittedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
