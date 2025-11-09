import 'package:go_router/go_router.dart';
import 'package:renty_play/features/feature_auth/ui/auth_page.dart';
import 'package:renty_play/features/feature_booking/ui/booking_page.dart';
import 'package:renty_play/features/feature_home/ui/home_page.dart';
import 'package:renty_play/features/feature_item_details/ui/item_details_page.dart';
import 'package:renty_play/features/feature_on_boarding/ui/on_boarding_page.dart';
import 'package:renty_play/features/feature_registration/ui/registration_page.dart';

class AppRouter {
  static final GoRouter route = GoRouter(
    initialLocation: OnboardingPage.routeName,
    routes: [
      GoRoute(
        path: OnboardingPage.routeName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AuthPage.routeName,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: RegistrationPage.routeName,
        builder: (context, state) => const RegistrationPage(),
      ),
      GoRoute(
        path: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: BookingPage.routeName,
        builder: (context, state) => const BookingPage(),
      ),
      GoRoute(
        path: ItemDetailsPage.routeName,
        builder: (context, state) => const ItemDetailsPage(),
      ),
    ],
  );
}
