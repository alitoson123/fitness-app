import 'package:flutter/foundation.dart';

@immutable
abstract class OnboardingState {
  final int currentPage;
  const OnboardingState({this.currentPage = 0});
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(currentPage: 0);
}

class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged({required super.currentPage});
}

class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState({required super.currentPage});
}
