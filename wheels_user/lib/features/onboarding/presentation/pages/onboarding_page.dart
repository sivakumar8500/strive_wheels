import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../login/presentation/bloc/login_bloc.dart';
import '../../../login/presentation/pages/auth_page.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_nav_button.dart';

/// Onboarding Page presenting the two introduction slides.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<OnboardingBloc>().add(const CheckFirstTimeEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BlocProvider<LoginBloc>(
          create: (_) => sl<LoginBloc>(),
          child: const AuthPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompletedState) {
          _navigateToLogin();
        } else if (state is OnboardingLoadedState) {
          if (_pageController.hasClients &&
              _pageController.page?.round() != state.currentPageIndex) {
            _pageController.animateToPage(
              state.currentPageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      builder: (context, state) {
        if (state is OnboardingLoadingState || state is OnboardingInitialState) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is OnboardingLoadedState) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  // Upper PageView Illustration Area
                  Expanded(
                    flex: 6,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.items.length,
                      onPageChanged: (index) {
                        context
                            .read<OnboardingBloc>()
                            .add(OnboardingPageChangedEvent(index));
                      },
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            item.imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.directions_bike,
                                size: 120,
                                color: AppColors.primaryBlue,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Content Section (Titles + Controls)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          state.items[state.currentPageIndex].title,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: isDark
                                ? AppColors.white
                                : AppColors.onboardingTextPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          state.items[state.currentPageIndex].subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.onboardingTextSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Bottom Control Row (Indicators & Next Button)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OnboardingIndicator(
                              count: state.items.length,
                              currentIndex: state.currentPageIndex,
                            ),
                            OnboardingNavButton(
                              onTap: () {
                                context
                                    .read<OnboardingBloc>()
                                    .add(const NextOnboardingPageEvent());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
