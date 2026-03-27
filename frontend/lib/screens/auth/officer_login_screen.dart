import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';
import '../../utils/global_state.dart';

/// Officer Login screen — responsive mobile + desktop.
class OfficerLoginScreen extends StatefulWidget {
  const OfficerLoginScreen({super.key});

  @override
  State<OfficerLoginScreen> createState() => _OfficerLoginScreenState();
}

class _OfficerLoginScreenState extends State<OfficerLoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          CivicAppBar(
            showBackArrow: !isDesktop,
            backgroundColor: isDesktop ? AppColors.surfaceContainerHighest : null,
            subtitle: isDesktop ? 'DISTRICT GOVERNANCE' : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isDesktop ? _desktopLayout() : _mobileLayout(),
                  const CivicFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── DESKTOP: Split layout with gradient hero ───
  Widget _desktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1024),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.05),
                  blurRadius: 50,
                  offset: const Offset(0, 25),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left: Hero gradient (5/12)
                    SizedBox(
                      width: 400,
                      child: Container(
                        padding: const EdgeInsets.all(48),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, AppColors.primaryContainer],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.account_balance, color: Colors.white.withValues(alpha: 0.9), size: 48),
                            const SizedBox(height: 16),
                            Text('The Digital\nPillar', style: GoogleFonts.publicSans(
                              fontSize: 36, fontWeight: FontWeight.w900,
                              color: Colors.white, letterSpacing: -1.5, height: 1.1,
                            )),
                            const SizedBox(height: 8),
                            Text('Government of India | District Portal', style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500,
                              color: AppColors.primaryFixedDim, letterSpacing: 0.5,
                            )),
                            const SizedBox(height: 48),
                            _heroFeature(Icons.verified_user, 'Secure Access',
                                'Multi-factor authentication enabled for all administrative levels.'),
                            const SizedBox(height: 24),
                            _heroFeature(Icons.gavel, 'Institutional Integrity',
                                'Access logs are audited as per national cybersecurity guidelines.'),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.only(top: 32),
                              decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                              ),
                              child: Text(
                                'AUTHORIZED PERSONNEL ONLY',
                                style: GoogleFonts.inter(
                                  fontSize: 10, fontWeight: FontWeight.w700,
                                  color: AppColors.primaryFixedDim.withValues(alpha: 0.5),
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right: Form (7/12)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(48),
                        color: AppColors.surface,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: _loginForm(isDesktop: true),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroFeature(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.tertiaryFixed, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white,
              )),
              const SizedBox(height: 4),
              Text(desc, style: GoogleFonts.inter(
                fontSize: 13, color: AppColors.primaryFixed.withValues(alpha: 0.7), height: 1.5,
              )),
            ],
          ),
        ),
      ],
    );
  }

  // ─── MOBILE: vertical stack ───
  Widget _mobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Officer Login', style: GoogleFonts.publicSans(
            fontSize: 36, fontWeight: FontWeight.w900,
            color: AppColors.onSurface, letterSpacing: -1,
          )),
          const SizedBox(height: 4),
          Text('अधिकारी लॉगिन', style: GoogleFonts.publicSans(
            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary,
          )),
          Container(
            height: 4, width: 48,
            margin: const EdgeInsets.only(top: 16, bottom: 32),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _loginForm(isDesktop: false),
        ],
      ),
    );
  }

  Widget _loginForm({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop) ...[
          Text('Officer Login', style: GoogleFonts.publicSans(
            fontSize: 36, fontWeight: FontWeight.w900,
            color: AppColors.onSurface, letterSpacing: -1,
          )),
          const SizedBox(height: 4),
          Text('अधिकारी लॉगिन', style: GoogleFonts.publicSans(
            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary,
          )),
          Container(
            height: 4, width: 48,
            margin: const EdgeInsets.only(top: 16, bottom: 40),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],

        // Login ID
        _fieldLabel('Login ID / लॉगिन आईडी', 'Required'),
        const SizedBox(height: 8),
        _iconInput(Icons.person, 'Enter ID', false, null),
        const SizedBox(height: 32),

        // Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Password / पासवर्ड', style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant,
            )),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset link sent to registered official email!')),
                );
              },
              child: Text('Forgot? / भूल गए?', style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary,
              )),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _iconInput(Icons.lock, '••••••••', true, IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.outline, size: 20,
          ),
        )),
        const SizedBox(height: 32),

        // Login button
        SizedBox(
            width: double.infinity,
            height: isDesktop ? 64 : 56,
            child: ElevatedButton(
              onPressed: () {
                GlobalState.isOfficer = true;
                Navigator.pushReplacementNamed(context, '/officer-dashboard');
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 4,
              shadowColor: AppColors.primary.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login / लॉगिन', style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w700, fontSize: 17,
                )),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),

        // Encrypted badge
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.enhanced_encryption, color: AppColors.onTertiaryFixed, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Identity Verified Access', style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface,
                    )),
                    Text('This session is monitored by the District IT Council.', style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.onSurfaceVariant,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline, size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Text('Need Assistance? / सहायता चाहिए?', style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant,
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label, String? trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant,
        )),
        if (trailing != null)
          Text(trailing.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w900,
            color: AppColors.primary.withValues(alpha: 0.6), letterSpacing: -0.5,
          )),
      ],
    );
  }

  Widget _iconInput(IconData icon, String hint, bool obscure, Widget? suffix) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        obscureText: obscure && _obscurePassword,
        style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.onSurface),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
          suffixIcon: suffix,
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: AppColors.outline),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
