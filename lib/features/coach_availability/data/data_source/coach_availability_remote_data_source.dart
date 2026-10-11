import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:fitness_app/core/widgets/availability_selector/availability_helper.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

class CoachAvailabilityRemoteDataSource {
  final FirestoreService firestoreService;

  CoachAvailabilityRemoteDataSource({required this.firestoreService});

  Future<CoachProfileModel?> getCoachProfile(String coachUid) async {
    LoggerService.info(
      'Fetching remote coach profile for availability: $coachUid',
      tag: 'CoachAvailabilityRemoteDataSource',
    );

    final doc = await firestoreService.getDoc(
      collection: AppConstants.coachProfilesCollection,
      docId: coachUid,
    );

    if (doc.exists && doc.data() != null) {
      return CoachProfileModel.fromJson(doc.data()!, uid: doc.id);
    }
    return null;
  }

  Future<void> updateCoachAvailability({
    required String coachUid,
    required List<DayAvailability> schedule,
    required int sessionDurationMinutes,
  }) async {
    LoggerService.info(
      'Updating remote coach availability: $coachUid',
      tag: 'CoachAvailabilityRemoteDataSource',
    );

    final activeDays = schedule
        .where((d) => d.isAvailable)
        .map((d) => d.day.name)
        .toList();

    final workingHoursData = <String, dynamic>{
      for (final availableDay in schedule.where((d) => d.isAvailable))
        availableDay.day.name: {
          'fromHour': availableDay.fromTime.hour,
          'fromMinute': availableDay.fromTime.minute,
          'toHour': availableDay.toTime.hour,
          'toMinute': availableDay.toTime.minute,
        },
    };

    final summary = AvailabilityHelper.buildRawSummaryString(schedule);

    final updatePayload = <String, dynamic>{
      'weeklyAvailability': schedule.map((e) => e.toMap()).toList(),
      'workingDays': activeDays,
      'workingHours': workingHoursData,
      'sessionDurationMinutes': sessionDurationMinutes,
      'availabilitySummary': summary,
    };

    await firestoreService.setData(
      collection: AppConstants.coachProfilesCollection,
      docId: coachUid,
      data: updatePayload,
      merge: true,
    );
  }
}
