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
  final List<DateTime> availableDates;
  final DateTime? selectedDate;
  final List<String> availableSlots;
  final String? selectedSlot;
  final String? selectedSport;
  final String notes;
  final String? errorMessage;

  const BookingRequestState({
    this.status = BookingRequestStatus.initial,
    this.coach,
    this.availableDates = const [],
    this.selectedDate,
    this.availableSlots = const [],
    this.selectedSlot,
    this.selectedSport,
    this.notes = '',
    this.errorMessage,
  });

  BookingRequestState copyWith({
    BookingRequestStatus? status,
    CoachProfileModel? coach,
    List<DateTime>? availableDates,
    DateTime? selectedDate,
    List<String>? availableSlots,
    String? selectedSlot,
    bool clearSelectedSlot = false,
    String? selectedSport,
    String? notes,
    String? errorMessage,
  }) {
    return BookingRequestState(
      status: status ?? this.status,
      coach: coach ?? this.coach,
      availableDates: availableDates ?? this.availableDates,
      selectedDate: selectedDate ?? this.selectedDate,
      availableSlots: availableSlots ?? this.availableSlots,
      selectedSlot: clearSelectedSlot ? null : (selectedSlot ?? this.selectedSlot),
      selectedSport: selectedSport ?? this.selectedSport,
      notes: notes ?? this.notes,
      errorMessage: errorMessage,
    );
  }
}
