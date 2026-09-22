/// Global application constants and configuration
abstract class AppConstants {
  static const String appName = 'CoachHub';

  // Hive Local Box & Keys
  static const String userBox = 'user_box';
  static const String currentUserKey = 'current_user';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String coachProfilesCollection = 'coach_profiles';
  static const String traineeProfilesCollection = 'trainee_profiles';
  static const String bookingsCollection = 'bookings';
  static const String verificationsCollection = 'coach_verifications';

  // Supported Sports
  static const List<String> sports = [
    'Gym',
    'Football',
    'Boxing',
    'Swimming',
    'Basketball',
    'Tennis',
    'Running',
    'Cycling',
    'Yoga',
    'Martial Arts',
    'Volleyball',
  ];

  // Experience levels
  static const List<Map<String, String>> experienceLevels = [
    {'id': 'beginner', 'label': 'Beginner', 'description': 'Just starting out'},
    {'id': 'intermediate', 'label': 'Intermediate', 'description': 'Some experience'},
    {'id': 'advanced', 'label': 'Advanced', 'description': 'High performance'},
  ];

  // Training goals
  static const List<Map<String, String>> trainingGoals = [
    {'id': 'fitness', 'label': 'General Fitness'},
    {'id': 'weight_loss', 'label': 'Weight Loss'},
    {'id': 'competition', 'label': 'Competition Prep'},
    {'id': 'skill', 'label': 'Skill Development'},
    {'id': 'fun', 'label': 'Fun & Recreation'},
  ];

  // Coach application steps
  static const List<String> coachApplicationSteps = [
    'Personal Information',
    'Professional Information',
    'Certifications & Experience',
    'Verification Documents',
    'Submit for Review',
  ];
}
