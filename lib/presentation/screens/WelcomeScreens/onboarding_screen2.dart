import 'package:flutter/material.dart';

// --- Constants ---
// It's often good practice to put these in a separate file (e.g., app_constants.dart or theme/app_colors.dart)
// For simplicity, they are here.

class _AppColors {
  static const Color background = Color.fromARGB(255, 255, 255, 255); // Très clair
  static const Color backButtonBackground = Color(0xFF3B82F6); // Bleu 
  static const Color backButtonIcon = Colors.white;
  static const Color primaryText = Color(0xFF071A2F);
  static const Color secondaryText = Colors.black54;
  static const Color buttonBackground = Color(0xFF3B82F6); // 
  static const Color buttonText = Colors.white;
}

class _AppSpacings {
  static const double screenPadding = 24.0;
  static const double s14 = 14.0;
  static const double s20 = 20.0;
  static const double s5 = 5.0;
  static const double s40 = 40.0;
}

class _AppDimens {
  static const double backButtonRadius = 36.0; // Or slightly smaller like 28.0 or 30.0
  static const double imageHeigh = 250.0;
  static const double buttonBorderRadius = 30.0;
}

class _AppFontSizes {
  static const double title = 24.0;
  static const double body = 16.0;
  static const double button = 16.0;
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_AppSpacings.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              const SizedBox(height: _AppSpacings.s5),
              _buildContentBody(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(top: _AppSpacings.s14, bottom: _AppSpacings.s14),
        decoration: BoxDecoration(
          color: _AppColors.backButtonBackground,
          borderRadius: BorderRadius.circular(_AppDimens.backButtonRadius),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _AppColors.backButtonIcon),
          tooltip: 'Go Back', // Accessibility: Good to add tooltips
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Fallback if there's no previous route, e.g., direct deep link to this screen
              Navigator.pushReplacementNamed(context, '/splash');
            }
          },
        ),
      );
  }

  Widget _buildContentBody(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Ensure vertical centering if space allows
        children: [
          Image.asset(
            'assets/images/image4.png', // Ensure this path is correct and image is in pubspec.yaml
            height: _AppDimens.imageHeigh,
            // Consider adding a semantic label for accessibility
            // semanticLabel: 'Illustration of AI empowering daily life',
          ),
          const SizedBox(height: _AppSpacings.s5),
          Text(
            "Empower Your\nDaily Life with AI",
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith( // Using headlineSmall as a base
              fontWeight: FontWeight.bold,
              color: _AppColors.primaryText,
              fontSize: _AppFontSizes.title, // Override if theme's default is not 24
            ) ?? const TextStyle( // Fallback style
              fontSize: _AppFontSizes.title,
              fontWeight: FontWeight.bold,
              color: _AppColors.primaryText,
            ),
          ),
          const SizedBox(height: _AppSpacings.s14),
          Text(
            "Get real-time voice feedback and smart guidance through your mobile camera.",
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith( // Using bodyLarge as a base
              color: _AppColors.secondaryText,
              fontSize: _AppFontSizes.body, // Override if theme's default is not 16
            ) ?? const TextStyle( // Fallback style
              fontSize: _AppFontSizes.body,
              color: _AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: _AppSpacings.s40),
          _buildGetStartedButton(context),
          const SizedBox(height: _AppSpacings.s20), // Spacing at the bottom
        ],
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _AppColors.buttonBackground,
        padding: const EdgeInsets.symmetric(
          horizontal: 48, // This could also be a constant if used elsewhere
          vertical: _AppSpacings.s14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_AppDimens.buttonBorderRadius),
        ),
        // Consider adding minimum size for touch targets
        // minimumSize: const Size(0, 48), // Example: minimum height of 48
      ),
      child: const Text(
        'Get Started',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _AppFontSizes.button,
          color: _AppColors.buttonText,
          // fontWeight: FontWeight.w500, // Optionally add font weight
        ),
      ),
    );
  }
}