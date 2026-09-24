import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/onboarding_item_model.dart';
import '../view_model/onboarding_cubit/onboarding_cubit.dart';
import '../view_model/onboarding_cubit/onboarding_state.dart';
import '../widgets/onboarding_bottom_controls.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = OnboardingItemModel.items;

    return BlocProvider(
      create: (context) => getIt<OnboardingCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SafeArea(
          child: BlocConsumer<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingCompletedState) {
                context.go(AppRoutes.signIn);
              }
            },
            builder: (context, state) {
              final cubit = context.read<OnboardingCubit>();
              final currentIndex = state.currentPage;

              return Column(
                children: [
                  OnboardingHeader(
                    showSkip: currentIndex < items.length - 1,
                    onSkip: () => cubit.completeOnboarding(),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: items.length,
                      onPageChanged: cubit.onPageChanged,
                      itemBuilder: (context, index) {
                        return OnboardingPageItem(item: items[index]);
                      },
                    ),
                  ),
                  OnboardingBottomControls(
                    currentIndex: currentIndex,
                    totalPages: items.length,
                    onNext: () => cubit.nextPage(_pageController, items.length),
                    onGetStarted: () => cubit.completeOnboarding(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
