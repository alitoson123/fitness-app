import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

enum BookingRequestStatus {
  initial,
  loadingSlots,
  ready,
  submitting,
  success,
  error,
}

class BookingRequestState {
  final BookingRequestStatus status;
  final CoachProfileModel? coach;
  final String bookingType; // 'session' | 'monthly'
  final List<DateTime> availableDates;
  final DateTime? selectedDate;
  final List<String> availableSlots;
  final String? selectedSlot;
  final String? selectedSport;
  final String? selectedLocation;
  final bool isOnlineTraining;
  final List<BookingSessionModel> selectedMonthlySessions;
  final int requiredMonthlySessions;
  final int durationMonths;
  final String notes;
  final String? errorMessage;

  /// Loading the free times failed (shown with a Retry button, so it isn't
  /// mistaken for "the coach is fully booked").
  final bool slotsLoadFailed;

  const BookingRequestState({
    this.status = BookingRequestStatus.initial,
    this.coach,
    this.bookingType = 'session',
    this.availableDates = const [],
    this.selectedDate,
    this.availableSlots = const [],
    this.selectedSlot,
    this.selectedSport,
    this.selectedLocation,
    this.isOnlineTraining = false,
    this.selectedMonthlySessions = const [],
    this.requiredMonthlySessions = 8,
    this.durationMonths = 1,
    this.notes = '',
    this.errorMessage,
    this.slotsLoadFailed = false,
  });

  bool get isMonthly => bookingType == 'monthly';
  bool get offersMonthly => (coach?.monthlyPriceUSD ?? 0) > 0;
  bool get isSession => bookingType != 'monthly';
  bool get isMonthlyComplete =>
      selectedMonthlySessions.length >= requiredMonthlySessions;

  double get totalPrice {
    final c = coach;
    if (c == null) return 0.0;
    return isMonthly ? (c.monthlyPriceUSD * durationMonths) : c.sessionPriceUSD;
  }

  bool get isDeliverySelected =>
      isOnlineTraining ||
      (selectedLocation != null && selectedLocation!.isNotEmpty);

  bool get isSubmitReady {
    if (coach == null || selectedSport == null || !isDeliverySelected) {
      return false;
    }
    if (isSession) return selectedDate != null && selectedSlot != null;
    return isMonthlyComplete;
  }

  BookingSessionModel? getSessionForDate(DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    for (final s in selectedMonthlySessions) {
      if (s.date == dateStr) return s;
    }
    return null;
  }

  bool hasSessionOnDate(DateTime date) => getSessionForDate(date) != null;

  BookingRequestState copyWith({
    BookingRequestStatus? status,
    CoachProfileModel? coach,
    String? bookingType,
    List<DateTime>? availableDates,
    DateTime? selectedDate,
    List<String>? availableSlots,
    String? selectedSlot,
    bool clearSelectedSlot = false,
    String? selectedSport,
    String? selectedLocation,
    bool clearSelectedLocation = false,
    bool? isOnlineTraining,
    List<BookingSessionModel>? selectedMonthlySessions,
    int? requiredMonthlySessions,
    int? durationMonths,
    String? notes,
    String? errorMessage,
    bool? slotsLoadFailed,
  }) {
    return BookingRequestState(
      status: status ?? this.status,
      coach: coach ?? this.coach,
      bookingType: bookingType ?? this.bookingType,
      availableDates: availableDates ?? this.availableDates,
      selectedDate: selectedDate ?? this.selectedDate,
      availableSlots: availableSlots ?? this.availableSlots,
      selectedSlot: clearSelectedSlot
          ? null
          : (selectedSlot ?? this.selectedSlot),
      selectedSport: selectedSport ?? this.selectedSport,
      selectedLocation: clearSelectedLocation
          ? null
          : (selectedLocation ?? this.selectedLocation),
      isOnlineTraining: isOnlineTraining ?? this.isOnlineTraining,
      selectedMonthlySessions:
          selectedMonthlySessions ?? this.selectedMonthlySessions,
      requiredMonthlySessions:
          requiredMonthlySessions ?? this.requiredMonthlySessions,
      durationMonths: durationMonths ?? this.durationMonths,
      notes: notes ?? this.notes,
      errorMessage: errorMessage,
      slotsLoadFailed: slotsLoadFailed ?? this.slotsLoadFailed,
    );
  }
}
