import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add dotenv import
import 'theme/app_theme.dart';
import 'screens/auth/login_selection_screen.dart';
import 'screens/auth/login_otp_screen.dart';
import 'screens/auth/officer_login_screen.dart';
import 'screens/dashboard/citizen_dashboard_screen.dart';
import 'screens/dashboard/officer_dashboard_screen.dart';
import 'screens/dashboard/complete_profile_screen.dart';
import 'screens/dashboard/register_complaint_screen.dart';
import 'screens/dashboard/track_status_screen.dart';
import 'screens/public/about_us_screen.dart';
import 'screens/public/contact_us_screen.dart';
import 'screens/public/help_faq_screen.dart';
import 'screens/public/privacy_policy_screen.dart';
import 'screens/dashboard/officer_dispatch_screen.dart';
import 'screens/dashboard/officer_analytics_screen.dart';
import 'screens/dashboard/officer_access_control_screen.dart';
import 'screens/dashboard/officer_archive_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  runApp(const CivicPulseApp());
}

class CivicPulseApp extends StatelessWidget {
  const CivicPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Civic Pulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routes: {
        '/': (context) => const LoginSelectionScreen(),
        '/login-otp': (context) => const LoginOtpScreen(),
        '/officer-login': (context) => const OfficerLoginScreen(),
        '/citizen-dashboard': (context) => const CitizenDashboardScreen(),
        '/officer-dashboard': (context) => const OfficerDashboardScreen(),        
        '/officer-dispatch': (context) => const OfficerDispatchScreen(),        
        '/officer-analytics': (context) => const OfficerAnalyticsScreen(),        
        '/officer-access': (context) => const OfficerAccessControlScreen(),        
        '/officer-archive': (context) => const OfficerArchiveScreen(),        
        '/complete-profile': (context) => const CompleteProfileScreen(),
        '/register-complaint': (context) => const RegisterComplaintScreen(),
        '/track-status': (context) => const TrackStatusScreen(),
        '/about-us': (context) => const AboutUsScreen(),
        '/contact-us': (context) => const ContactUsScreen(),
        '/help-faq': (context) => const HelpFaqScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
      },
    );
  }
}
