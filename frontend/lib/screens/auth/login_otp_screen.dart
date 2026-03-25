import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';

/// Citizen OTP Login screen — responsive mobile + desktop.
class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  bool _otpSent = false;
  int _resendSeconds = 30;
  Timer? _timer;
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(5, (_) => TextEditingController());

  void _sendOtp() {
    setState(() {
      _otpSent = true;
      _resendSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          CivicAppBar(
            showBackArrow: true,
            subtitle: isDesktop ? null : null,
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

  // ─── DESKTOP: 12-col editorial + auth card ───
  Widget _desktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Editorial
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryFixed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SECURE PORTAL',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onTertiaryFixed,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Sign In to Your Account',
                      style: GoogleFonts.publicSans(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'अपने खाते में साइन इन करें',
                      style: GoogleFonts.publicSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Text(
                        'Access government services, track applications, and manage your digital identity with secure, unified authentication.',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          color: AppColors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Verified Identity card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                            ),
                            child: const Icon(Icons.shield, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Verified Identity', style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700, color: AppColors.onSurface,
                              )),
                              Text('Authenticated by National Informatics Centre', style: GoogleFonts.inter(
                                fontSize: 13, color: AppColors.onSurfaceVariant,
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              // Right: Auth Card
              SizedBox(
                width: 480,
                child: Container(
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                    boxShadow: [
                      BoxShadow(color: AppColors.onSurface.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: _authForm(isDesktop: true),
                ),
              ),
            ],
          ),
        ),
      ),
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
          Text(
            'Sign In.',
            style: GoogleFonts.publicSans(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              letterSpacing: -1.5,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Citizen OTP Access',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          _authForm(isDesktop: false),
        ],
      ),
    );
  }

  Widget _authForm({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop) ...[
          // Tabs
          Row(
            children: [
              Expanded(child: _authTab('Mobile OTP', 'मोबाइल ओटीपी', Icons.smartphone, true)),
              const SizedBox(width: 16),
              Expanded(child: _authTab('Aadhar', 'आधार', Icons.fingerprint, false)),
            ],
          ),
          const SizedBox(height: 40),
        ],
        // Phone label
        Text(
          isDesktop
              ? 'Verify through Mobile OTP / मोबाइल ओटीपी के माध्यम से सत्यापित करें'
              : 'Your registered mobile number',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        // Phone input
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('+91', style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant,
                    )),
                    Container(
                      width: 1, height: 24,
                      margin: const EdgeInsets.only(left: 16),
                      color: AppColors.outlineVariant,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.inter(
                    fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Mobile Number',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15, color: AppColors.outline, fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        if (!_otpSent)
          // Send OTP button
          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton(
              onPressed: _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: Text(
                'SEND OTP / ओटीपी भेजें',
                style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),

        if (_otpSent) ...[
          // OTP fields
          Text('Enter 5-digit OTP', style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant,
          )),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 4 ? 12 : 0),
                height: 56,
                child: TextField(
                  controller: _otpControllers[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 4) FocusScope.of(context).nextFocus();
                  },
                ),
              ),
            )),
          ),
          const SizedBox(height: 16),
          // Resend timer
          Center(
            child: Text(
              _resendSeconds > 0
                  ? 'Resend in ${_resendSeconds}s'
                  : 'Resend OTP',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _resendSeconds > 0 ? AppColors.outline : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/citizen-dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: Text(
                'VERIFY & PROCEED',
                style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ],

        if (isDesktop) ...[
          const SizedBox(height: 24),
          Center(child: Text('Or sign in using', style: GoogleFonts.inter(
            fontSize: 13, color: AppColors.onSurfaceVariant,
          ))),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryContainer,
                foregroundColor: AppColors.onSecondaryContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: Text(
                'Verify through Aadhar / आधार के माध्यम से',
                style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Footer links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footerLink('FORGOT PASSWORD?'),
              const SizedBox(width: 32),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/complete-profile'),
                child: _footerLink('NEW REGISTRATION'),
              ),
            ],
          ),
        ],

        if (!isDesktop) ...[
          const SizedBox(height: 32),
          // Trust badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiaryFixed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user, color: AppColors.tertiary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Secure AES-256 | National e-Auth Framework',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onTertiaryFixedVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _authTab(String label, String hindiLabel, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
        color: isActive ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surfaceContainerLow,
      ),
      child: Column(
        children: [
          Icon(icon, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
          )),
          Text(hindiLabel, style: GoogleFonts.inter(
            fontSize: 10, color: isActive ? AppColors.primary.withValues(alpha: 0.8) : AppColors.onSurfaceVariant.withValues(alpha: 0.8),
          )),
        ],
      ),
    );
  }

  Widget _footerLink(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 2,
      ),
    );
  }
}
