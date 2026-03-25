import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_bottom_nav.dart';
import '../../widgets/civic_footer.dart';

/// Complete Profile Screen — responsive mobile + desktop.
class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: isDesktop
          ? null
          : CivicBottomNav(
              activeIndex: 3,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/citizen-dashboard');
                } else if (index == 1) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/register-complaint',
                  );
                } else if (index == 2) {
                  Navigator.pushReplacementNamed(context, '/track-status');
                } else if (index == 3) {
                  Navigator.pushReplacementNamed(context, '/complete-profile');
                }
              },
            ),
      body: Column(
        children: [
          CivicAppBar(showMenuIcon: !isDesktop, showAvatar: !isDesktop),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isDesktop ? _desktopLayout(context) : _mobileLayout(context),
                  const CivicFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── DESKTOP: 12-col grid (4-col photo, 8-col form) ───
  Widget _desktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1024),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _editorialHeader(true),
              const SizedBox(height: 64),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left (4/12): Photo Upload
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _photoUploadSurface(true),
                        const SizedBox(height: 16),
                        Text(
                          'Required for official digital certificates and verification services.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  // Right (8/12): Form
                  Expanded(flex: 8, child: _profileForm(context, true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── MOBILE: Single column ───
  Widget _mobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _editorialHeader(false),
          const SizedBox(height: 48),
          Center(child: _photoUploadSurface(false)),
          const SizedBox(height: 48),
          _profileForm(context, false),
        ],
      ),
    );
  }

  Widget _editorialHeader(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDesktop) ...[
          Text(
            'STEP 2 OF 2',
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          'Complete Your Profile',
          style: GoogleFonts.publicSans(
            fontSize: isDesktop ? 56 : 36,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            letterSpacing: isDesktop ? -2 : -1,
            height: 1.1,
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(height: 8),
          Text(
            'अपनी प्रोफ़ाइल पूरी करें',
            style: GoogleFonts.publicSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary.withValues(alpha: 0.8),
            ),
          ),
          Container(
            height: 6,
            width: 96,
            margin: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ] else ...[
          const SizedBox(height: 16),
          Text(
            'Ensure your digital identity is accurate to access government services seamlessly.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _photoUploadSurface(bool isDesktop) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: isDesktop ? 256 : 128,
              height: isDesktop ? 320 : 128,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(isDesktop ? 16 : 100),
                border: Border.all(
                  color: isDesktop
                      ? AppColors.outlineVariant
                      : AppColors.surfaceContainerLow,
                  width: isDesktop ? 2 : 4,
                  style: isDesktop ? BorderStyle.solid : BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDesktop ? Icons.upload_file : Icons.person,
                      size: isDesktop ? 48 : 56,
                      color: AppColors.outline,
                    ),
                    if (isDesktop) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Upload Passport Size Photo',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'JPEG or PNG, Max 2MB',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (!isDesktop) // Floating action button for mobile
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        if (!isDesktop) ...[
          const SizedBox(height: 16),
          Text(
            'Upload a clear passport-sized photo (Max 2MB)',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _profileForm(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formField(
          'Full Name (As per ID)',
          'e.g. Arjan Singh',
          isDesktop,
          null,
        ),
        const SizedBox(height: 24),

        if (isDesktop)
          Row(
            children: [
              Expanded(
                child: _formField(
                  'Email Address',
                  'example@nic.in',
                  isDesktop,
                  null,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _formField(
                  'Phone Number',
                  '+91 98765 43210',
                  isDesktop,
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.tertiaryFixedDim,
                  ),
                  readOnly: true,
                  verified: true,
                ),
              ),
            ],
          )
        else
          _formField('Identity Number', 'XXXX - XXXX - XXXX', isDesktop, null),

        const SizedBox(height: 24),
        if (isDesktop)
          _genderSelection(isDesktop)
        else
          Row(
            children: [
              Expanded(
                child: _formField(
                  'Date of Birth',
                  'DD/MM/YYYY',
                  isDesktop,
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _formField(
                  'Gender',
                  'Select',
                  isDesktop,
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

        const SizedBox(height: 24),
        _formField(
          'Residential Address',
          'Enter your full permanent address',
          isDesktop,
          null,
          maxLines: 4,
        ),

        const SizedBox(height: 32),
        if (!isDesktop) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiaryFixed.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.verified_user,
                  color: AppColors.tertiary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your data is encrypted using 256-bit military-grade protocols and will only be used for official verification.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.onTertiaryFixedVariant,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Action Buttons
        Row(
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.end
              : MainAxisAlignment.center,
          children: [
            if (!isDesktop)
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          '/citizen-dashboard',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Finalize Registration',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Save as Draft',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  '/citizen-dashboard',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryContainer,
                  foregroundColor: AppColors.onSecondaryContainer,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  children: [
                    Text(
                      'Submit & Proceed',
                      style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _formField(
    String label,
    String hint,
    bool isDesktop,
    Widget? suffix, {
    int maxLines = 1,
    bool readOnly = false,
    bool verified = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isDesktop ? label.toUpperCase() : label,
          style: isDesktop
              ? GoogleFonts.publicSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                )
              : GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: readOnly
                ? AppColors.surfaceContainerLow
                : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(isDesktop ? 8 : 12),
          ),
          child: TextField(
            readOnly: readOnly,
            maxLines: maxLines,
            style: GoogleFonts.inter(
              fontSize: isDesktop ? 16 : 15,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: AppColors.outline),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(isDesktop ? 20 : 16),
              suffixIcon: suffix,
            ),
          ),
        ),
        if (verified) ...[
          const SizedBox(height: 4),
          Text(
            'VERIFIED VIA OTP',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.tertiary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _genderSelection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENDER',
          style: GoogleFonts.publicSans(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _genderPill('Male', true)),
            const SizedBox(width: 16),
            Expanded(child: _genderPill('Female', false)),
            const SizedBox(width: 16),
            Expanded(child: _genderPill('Other', false)),
          ],
        ),
      ],
    );
  }

  Widget _genderPill(String label, bool isSelected) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryFixed : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.onPrimaryFixed : AppColors.onSurface,
        ),
      ),
    );
  }
}
