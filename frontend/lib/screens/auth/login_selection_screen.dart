import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';

/// Login Selection screen — responsive mobile + desktop.
class LoginSelectionScreen extends StatelessWidget {
  const LoginSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          const CivicAppBar(
            showProfileButton: false,
            showLoginButton: false,
            showDashboardButton: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: isDesktop ? 96 : 48,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 1024 : 600,
                        ),
                        child: Column(
                          children: [
                            // ── Hero Text ──
                            Text(
                              isDesktop
                                  ? 'Welcome to Civic Pulse'
                                  : 'Select Your Portal.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.publicSans(
                                fontSize: isDesktop ? 56 : 48,
                                fontWeight: FontWeight.w900,
                                color: AppColors.onSurface,
                                letterSpacing: isDesktop ? -3 : -2.5,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: isDesktop ? 500 : 300,
                              ),
                              child: Text(
                                isDesktop
                                    ? 'Select your portal to access government services and administrative tools.'
                                    : 'Access authoritative government services and administrative controls through our secure gateways.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: isDesktop ? 18 : 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            SizedBox(height: isDesktop ? 64 : 48),

                            // ── Portal Cards ──
                            isDesktop
                                ? _desktopCards(context)
                                : _mobileCards(context),

                            SizedBox(height: isDesktop ? 80 : 48),

                            // ── Trust Indicators ──
                            _trustIndicators(isDesktop),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const CivicFooter(showLogin: false, showDashboard: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopCards(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _desktopPortalCard(
            context: context,
            bgColor: AppColors.surfaceContainerLowest,
            accentColor: AppColors.tertiaryFixed,
            icon: Icons.person,
            iconColor: AppColors.tertiary,
            title: 'Citizen Login',
            hindiTitle: 'नागरिक लॉगिन',
            description: 'Access municipal services directly.',
            ctaLabel: 'Proceed to Portal',
            ctaIcon: Icons.arrow_forward,
            onTap: () => Navigator.of(context).pushNamed('/login-otp'),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: _desktopPortalCard(
            context: context,
            bgColor: AppColors.surfaceContainerLow,
            accentColor: AppColors.secondaryContainer,
            icon: Icons.shield,
            iconColor: AppColors.onSecondaryFixedVariant,
            title: 'Officer Login',
            hindiTitle: 'अधिकारी लॉगिन',
            description: 'Internal gateway for service management.',
            ctaLabel: 'Internal Access',
            ctaIcon: Icons.lock_open,
            onTap: () => Navigator.of(context).pushNamed('/officer-login'),
          ),
        ),
      ],
    );
  }

  Widget _desktopPortalCard({
    required BuildContext context,
    required Color bgColor,
    required Color accentColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String hindiTitle,
    required String description,
    required String ctaLabel,
    required IconData ctaIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -32,
                right: -32,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    style: GoogleFonts.publicSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hindiTitle,
                    style: GoogleFonts.publicSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    children: [
                      Text(
                        ctaLabel,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(ctaIcon, color: AppColors.primary, size: 20),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileCards(BuildContext context) {
    return Column(
      children: [
        _mobilePortalCard(
          bgColor: AppColors.surfaceContainerLowest,
          icon: Icons.how_to_reg,
          iconBg: AppColors.primaryContainer.withValues(alpha: 0.1),
          title: 'Citizen Portal',
          description:
              'Register grievances, apply for certificates, and view local community updates.',
          buttonLabel: 'Enter Citizen Space',
          buttonIcon: Icons.arrow_forward,
          buttonColor: AppColors.primary,
          buttonTextColor: AppColors.onPrimary,
          onTap: () => Navigator.of(context).pushNamed('/login-otp'),
        ),
        const SizedBox(height: 24),
        _mobilePortalCard(
          bgColor: AppColors.surfaceContainerLow,
          icon: Icons.admin_panel_settings,
          iconBg: AppColors.secondaryContainer.withValues(alpha: 0.2),
          title: 'Officer Portal',
          description:
              'Administrative access for verified municipal staff and law enforcement officials.',
          buttonLabel: 'Admin Login',
          buttonIcon: Icons.lock_open,
          buttonColor: AppColors.secondaryContainer,
          buttonTextColor: AppColors.onSecondaryContainer,
          onTap: () => Navigator.of(context).pushNamed('/officer-login'),
        ),
      ],
    );
  }

  Widget _mobilePortalCard({
    required Color bgColor,
    required IconData icon,
    required Color iconBg,
    required String title,
    required String description,
    required String buttonLabel,
    required IconData buttonIcon,
    required Color buttonColor,
    required Color buttonTextColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.publicSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: buttonTextColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonLabel,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(buttonIcon, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trustIndicators(bool isDesktop) {
    return Wrap(
      spacing: isDesktop ? 48 : 24,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _trustBadge(Icons.verified_user, 'Secure Auth Protocol'),
        _trustBadge(Icons.gavel, 'Editorial Grade Governance'),
        _trustBadge(Icons.enhanced_encryption, 'End-to-End Encrypted'),
      ],
    );
  }

  static Widget _trustBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 12),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.publicSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
