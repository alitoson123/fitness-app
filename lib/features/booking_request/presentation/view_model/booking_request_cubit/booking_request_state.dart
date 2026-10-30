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
  final int weeklyFrequency;
  final int durationMonths;
  final String notes;
  final String? errorMessage;

  const BookingRequestState({
    this.status = BookingRequestStatus.initial,
    this.coach,
    this.bookingType = 'session',
    this.availableDates = const [],
    this.selectedDate,
    this.availableSlots = const [],
    this.selectedSlot,
    this.selectedSport,
    this.weeklyFrequency = 3,
    this.durationMonths = 1,
    this.notes = '',
    this.errorMessage,
  });

  bool get isMonthly => bookingType == 'monthly';
  bool get isSession => bookingType != 'monthly';

  double get totalPrice {
    final c = coach;
    if (c == null) return 0.0;
    return isMonthly ? (c.monthlyPriceUSD * durationMonths) : c.sessionPriceUSD;
  }

  bool get isSubmitReady {
    if (coach == null || selectedDate == null || selectedSport == null) {
      return false;
    }
    if (isSession) return selectedSlot != null;
    return true;
  }

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
    int? weeklyFrequency,
    int? durationMonths,
    String? notes,
    String? errorMessage,
  }) {
    return BookingRequestState(
      status: status ?? this.status,
      coach: coach ?? this.coach,
      bookingType: bookingType ?? this.bookingType,
      availableDates: availableDates ?? this.availableDates,
      selectedDate: selectedDate ?? this.selectedDate,
      availableSlots: availableSlots ?? this.availableSlots,
      selectedSlot:
          clearSelectedSlot ? null : (selectedSlot ?? this.selectedSlot),
      selectedSport: selectedSport ?? this.selectedSport,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      durationMonths: durationMonths ?? this.durationMonths,
      notes: notes ?? this.notes,
      errorMessage: errorMessage,
    );
  }
}
