import 'package:fitness_app/features/onboarding/data/data_source/onboarding_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingLocalDataSource localDataSource;

  OnboardingCubit({required this.localDataSource})
    : super(const OnboardingInitial());

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void onPageChanged(int index) {
    _currentIndex = index;
    emit(OnboardingPageChanged(currentPage: index));
  }

  void nextPage(PageController pageController, int totalPages) {
    if (_currentIndex < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      completeOnboarding();
    }
  }

  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingCompleted();
    emit(OnboardingCompletedState(currentPage: _currentIndex));
  }
}
