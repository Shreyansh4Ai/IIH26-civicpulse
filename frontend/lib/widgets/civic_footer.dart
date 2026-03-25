import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_helper.dart';

/// Reusable footer — desktop: horizontal row; mobile: centered stack.

class CivicFooter extends StatelessWidget {
  final bool showLogin;
  final bool showDashboard;
  const CivicFooter({
    super.key,
    this.showLogin = true,
    this.showDashboard = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerHighest,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 24,
        vertical: isDesktop ? 36 : 28,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 760;

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      _footerLink(context, 'About Us', '/about-us'),
                      _footerLink(context, 'Privacy Policy', '/privacy-policy'),
                      _footerLink(context, 'Contact Us', '/contact-us'),
                      _footerLink(context, 'Help Desk', '/help-faq'),
                      if (showLogin) _footerLink(context, 'Login', '/'),
                      if (showDashboard)
                        _footerLink(
                          context,
                          'Dashboard',
                          _resolveDashboardRoute(context),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '© 2026 Civic Pulse. All rights reserved.',
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    color: AppColors.outline,
                    height: 1.5,
                  ),
                ),
              ],
            );
          }

          final rightWidth = constraints.maxWidth * 0.58;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '© 2026 Civic Pulse. All rights reserved.',
                style: GoogleFonts.publicSans(
                  fontSize: 13,
                  color: AppColors.outline,
                  height: 1.5,
                ),
              ),
              SizedBox(
                width: rightWidth,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Wrap(
                    spacing: 28,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      _footerLink(context, 'About Us', '/about-us'),
                      _footerLink(context, 'Privacy Policy', '/privacy-policy'),
                      _footerLink(context, 'Contact Us', '/contact-us'),
                      _footerLink(context, 'Help Desk', '/help-faq'),
                      if (showLogin) _footerLink(context, 'Login', '/'),
                      if (showDashboard)
                        _footerLink(
                          context,
                          'Dashboard',
                          _resolveDashboardRoute(context),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _footerLink(
    BuildContext context,
    String label,
    String routeName,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _navigateToRoute(context, routeName);
        },
        child: Text(
          label,
          style: GoogleFonts.publicSans(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static void _navigateToRoute(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) {
      return;
    }
    Navigator.pushNamed(context, routeName);
  }

  static String _resolveDashboardRoute(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';
    if (routeName.startsWith('/officer')) {
      return '/officer-dashboard';
    }
    return '/citizen-dashboard';
  }
}
