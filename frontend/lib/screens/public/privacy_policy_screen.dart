import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';
import '../../theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CivicAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(isDesktop),
            _buildMainContent(isDesktop),
            const CivicFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryContainer,
      padding: EdgeInsets.fromLTRB(isDesktop ? 64 : 24, 80, isDesktop ? 64 : 24, 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.onPrimaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              'Last Updated: March 2024',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Privacy Policy',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 64 : 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              color: AppColors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'गोपनीयता नीति',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.w900,
              color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 80,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildSidebar()),
                const SizedBox(width: 80),
                Expanded(flex: 7, child: _buildDocumentText(isDesktop)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSidebar(),
                const SizedBox(height: 48),
                _buildDocumentText(isDesktop),
              ],
            ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contents',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _navLink('1. Introduction', true),
          _navLink('2. Data We Collect', false),
          _navLink('3. Purpose of Collection', false),
          _navLink('4. Data Sharing', false),
          _navLink('5. Your Rights', false),
        ],
      ),
    );
  }

  Widget _navLink(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppColors.primary : AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildDocumentText(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('1. Introduction'),
        _paragraph('Civic Pulse operates as the unified digital bridge for citizen grievance redressal within India. This Privacy Policy details how we handle the personal and unclassified data you share on our platform.'),
        
        const SizedBox(height: 48),
        _sectionTitle('2. Data We Collect'),
        _paragraph('To ensure verified and accountable grievance registrations, we collect essential identifying information.'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Information Automatically Logged',
                style: GoogleFonts.publicSans(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _listItem('IP Address and Device IDs for security auditing.'),
              _listItem('Geotagged metadata from uploaded evidence (photos/videos).'),
              _listItem('Session timestamps and portal interaction behaviors.'),
            ],
          ),
        ),

        const SizedBox(height: 48),
        _sectionTitle('3. Purpose of Collection'),
        _paragraph('Your data strictly serves the operational requirements of the grievance redressal ecosystem:'),
        const SizedBox(height: 16),
        _listItemIcon(Icons.verified, 'Identity Verification via Aadhaar/Mobile OTP to prevent fraudulent claims.'),
        const SizedBox(height: 16),
        _listItemIcon(Icons.map, 'Geospatial Routing to assign the exact nodal officer based on complaint location.'),
        const SizedBox(height: 16),
        _listItemIcon(Icons.analytics, 'Analytics to measure departmental performance and SLA adhearance.'),

        const SizedBox(height: 48),
        _sectionTitle('4. Data Sharing'),
        _paragraph('We adopt a strict Need-to-Know principle. Your data is ONLY shared with:'),
        _paragraph('• The specific department handling your case.\n• Governing audit authorities when legally mandated.\n• NIC infrastructure operators holding clearance.'),
        
        const SizedBox(height: 48),
        _sectionTitle('5. Your Rights'),
        _paragraph('Under governing laws, citizens maintain sovereign rights over their digital profile:'),
        const SizedBox(height: 24),
        
        isDesktop
            ? Row(
                children: [
                  Expanded(child: _rightsCard('Access', 'Request a copy of your data')),
                  const SizedBox(width: 16),
                  Expanded(child: _rightsCard('Correction', 'Modify outdated records')),
                  const SizedBox(width: 16),
                  Expanded(child: _rightsCard('Erasure', 'Delete closed complaint history')),
                ],
              )
            : Column(
                children: [
                  _rightsCard('Access', 'Request a copy of your data'),
                  const SizedBox(height: 16),
                  _rightsCard('Correction', 'Modify outdated records'),
                  const SizedBox(height: 16),
                  _rightsCard('Erasure', 'Delete closed complaint history'),
                ],
              ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.publicSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 18,
        height: 1.6,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _listItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: GoogleFonts.inter(fontSize: 18, height: 1.6, color: AppColors.primary)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 16, height: 1.6, color: AppColors.onSurface))),
        ],
      ),
    );
  }

  Widget _listItemIcon(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
            child: Text(text, style: GoogleFonts.inter(fontSize: 18, height: 1.6, color: AppColors.onSurfaceVariant))),
      ],
    );
  }

  Widget _rightsCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
