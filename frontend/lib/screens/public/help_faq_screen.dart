import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';
import '../../theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CivicAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSearch(isDesktop),
            _buildCategories(context, isDesktop),
            _buildFaqs(isDesktop),
            _buildStillNeedHelp(context, isDesktop),
            const CivicFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSearch(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerLowest,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 64 : 24,
        80,
        isDesktop ? 64 : 24,
        64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'How can we help you?',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 64 : 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'हम आपकी कैसे मदद कर सकते हैं?',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            width: isDesktop ? 800 : double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search knowledge base... (e.g. "Track Status")',
                hintStyle: GoogleFonts.inter(
                  fontSize: 18,
                  color: AppColors.onSurfaceVariant,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Icon(Icons.search, size: 32, color: AppColors.primary),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
              ),
              style: GoogleFonts.inter(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse Topics',
            style: GoogleFonts.publicSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 40),
          isDesktop
              ? Row(
                  children: [
                    Expanded(
                      child: _categoryCard(
                        context,
                        'Getting Started',
                        'Account creation & basics',
                        Icons.rocket_launch,
                        AppColors.primaryContainer,
                        AppColors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _categoryCard(
                        context,
                        'Aadhaar Verification',
                        'e-KYC & linking issues',
                        Icons.fingerprint,
                        AppColors.secondaryContainer,
                        AppColors.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _categoryCard(
                        context,
                        'Tracking Status',
                        'Understanding timelines',
                        Icons.track_changes,
                        AppColors.tertiaryContainer,
                        AppColors.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _categoryCard(
                        context,
                        'Technical Support',
                        'App errors & bugs',
                        Icons.support_agent,
                        AppColors.errorContainer,
                        AppColors.onErrorContainer,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _categoryCard(
                            context,
                            'Getting Started',
                            'Account basics',
                            Icons.rocket_launch,
                            AppColors.primaryContainer,
                            AppColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _categoryCard(
                            context,
                            'Verify',
                            'e-KYC issues',
                            Icons.fingerprint,
                            AppColors.secondaryContainer,
                            AppColors.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _categoryCard(
                            context,
                            'Tracking',
                            'Timeline query',
                            Icons.track_changes,
                            AppColors.tertiaryContainer,
                            AppColors.onTertiaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _categoryCard(
                            context,
                            'Tech Support',
                            'App errors',
                            Icons.support_agent,
                            AppColors.errorContainer,
                            AppColors.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _categoryCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color bg,
    Color textC,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Help articles for "$title" are currently being updated in the demo.',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: textC, size: 32),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textC,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: textC.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqs(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerLow,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 80,
      ),
      child: Center(
        child: SizedBox(
          width: isDesktop ? 800 : double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Frequently Asked Questions',
                style: GoogleFonts.publicSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 40),
              _faqTile(
                'How do I register a new complaint?',
                'Once logged into your Citizen Dashboard, click the prominent "Submit New Request" button. You will be guided through a simple form where you can select the grievance category, describe the issue, and optionally upload geotagged photo evidence. A unique tracking ID will be generated upon submission.',
              ),
              _faqTile(
                'Is my identity kept confidential?',
                'Yes. While Aadhaar or Mobile OTP verification is required to prevent spam, your personal identity is masked in the public ledger and only accessible to the investigating nodal officer handling your specific grievance.',
              ),
              _faqTile(
                'What is the typical resolution time for civic issues?',
                'Resolution timeframes vary strictly by category. Critical issues (e.g., live wires, severe water leaks) are mandated for action within 24-48 hours. Standard municipal issues are typically addressed within 7-14 working days as per the Citizen Charter.',
              ),
              _faqTile(
                'Can I track my complaint without an account?',
                'Yes, the homepage features a "Track Request" option where you can enter your 12-digit Complaint Tracking ID to view real-time status updates without needing to log in.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.onSurfaceVariant,
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          title: Text(
            question,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                answer,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.6,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStillNeedHelp(BuildContext context, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 80,
      ),
      child: Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: isDesktop
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Still need help?',
                          style: GoogleFonts.publicSans(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Can\'t find the answer you\'re looking for? Our support team is ready to assist you.',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.onPrimaryContainer.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/contact-us');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Contact Support',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Text(
                    'Still need help?',
                    style: GoogleFonts.publicSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Can\'t find the answer you\'re looking for? Our support team is ready to assist you.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.onPrimaryContainer.withValues(
                        alpha: 0.8,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/contact-us');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Contact Support',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
