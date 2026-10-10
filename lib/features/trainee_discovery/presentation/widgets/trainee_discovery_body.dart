import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_discovery_cubit/coach_discovery_cubit.dart';
import '../view_model/coach_discovery_cubit/coach_discovery_states.dart';
import 'coach_filter_bottom_sheet.dart';
import 'coach_list_view.dart';
import 'coach_search_bar.dart';
import 'empty_discovery_state.dart';
import 'shimmer_coach_list_loading.dart';
import 'sports_horizontal_selector.dart';

class TraineeDiscoveryBody extends StatelessWidget {
  const TraineeDiscoveryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachDiscoveryCubit, CoachDiscoveryState>(
      builder: (context, state) {
        if (state is CoachDiscoveryLoading || state is CoachDiscoveryInitial) {
          return const Column(
            children: [Expanded(child: ShimmerCoachListLoading())],
          );
        }

        if (state is CoachDiscoveryError) {
          return _buildErrorState(context, state.errorMessage);
        }

        if (state is CoachDiscoveryLoaded) {
          final cubit = context.read<CoachDiscoveryCubit>();
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final primary = isDark ? AppColors.flameRed : AppColors.primary;

          return Column(
            children: [
              SizedBox(height: 8.h),
              CoachSearchBar(
                initialQuery: state.searchQuery,
                onQueryChanged: cubit.search,
                activeFiltersCount: state.filter.activeFiltersCount,
                onFilterTap: () => CoachFilterBottomSheet.show(
                  context,
                  initialFilter: state.filter,
                  onApply: cubit.applyFilters,
                ),
              ),
              SizedBox(height: 12.h),
              SportsHorizontalSelector(
                selectedSport: state.filter.selectedSport,
                onSportSelected: cubit.selectSport,
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: RefreshIndicator(
                  color: primary,
                  onRefresh: () => cubit.refreshCoaches(),
                  child: state.filteredCoaches.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            EmptyDiscoveryState(
                              onClearFilters: cubit.clearFilters,
                            ),
                          ],
                        )
                      : CoachListView(
                          coaches: state.filteredCoaches,
                          onCoachTap: (coach) {
                            context.push(AppRoutes.coachDetails, extra: coach);
                          },
                        ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return RefreshIndicator(
      color: primary,
      onRefresh: () => context.read<CoachDiscoveryCubit>().loadCoaches(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.r,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        S.of(context).errorLoadingCoaches,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<CoachDiscoveryCubit>().loadCoaches(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                        ),
                        child: Text(
                          S.of(context).retry,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
