import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_bottom_nav.dart';
import '../../widgets/civic_footer.dart';
import '../../widgets/civic_side_nav.dart';

/// Citizen Dashboard — responsive mobile + desktop.
class CitizenDashboardScreen extends StatelessWidget {
  const CitizenDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: isDesktop
          ? null
          : CivicBottomNav(
              activeIndex: 0,
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
      body: isDesktop ? _desktopLayout(context) : _mobileLayout(context),
    );
  }

  // ─── DESKTOP ───
  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        const CivicSideNav(variant: 'citizen', activeIndex: 0),
        Expanded(
          child: Column(
            children: [
              CivicAppBar(
                navLinks: const ['About Us', 'Contact Us', 'Dashboard'],
                showAvatar: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1024),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _heroSection(context, true),
                          const SizedBox(height: 48),
                          _statsRow(true),
                          const SizedBox(height: 48),
                          _requestsSection(true),
                          const SizedBox(height: 48),
                          _supportBanner(),
                          const SizedBox(height: 48),
                          const CivicFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── MOBILE ───
  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        const CivicAppBar(showMenuIcon: true, showAvatar: true),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroSection(context, false),
                _statsRow(false),
                const SizedBox(height: 24),
                _requestsSection(false),
                const SizedBox(height: 24),
                _neighborhoodPulse(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        const CivicFooter(),
      ],
    );
  }

  Widget _heroSection(BuildContext context, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isDesktop ? 0 : 8),
          Text(
            isDesktop
                ? 'Hello, Arjun.\nYour district at a glance.'
                : 'Hello, Arjun.\nYour district at a glance.',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(height: 8),
            Text(
              'अर्जुन, आपका जिला एक नज़र में।',
              style: GoogleFonts.publicSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'अर्जुन, आपका जिला एक नज़र में।',
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            isDesktop
                ? 'Track your service requests, manage applications, and stay connected with your neighborhood.'
                : 'Track your service requests, manage applications, and stay connected with your neighborhood.',
            style: GoogleFonts.inter(
              fontSize: isDesktop ? 17 : 15,
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          if (!isDesktop) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/register-complaint'),
                icon: const Icon(Icons.add, size: 20),
                label: Text(
                  'New Request',
                  style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryContainer,
                  foregroundColor: AppColors.onSecondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statsRow(bool isDesktop) {
    final stats = isDesktop
        ? [
            _StatData(
              'Active Requests',
              'सक्रिय अनुरोध',
              '4',
              AppColors.primary,
            ),
            _StatData('Resolved', 'समाधान किया गया', '12', AppColors.tertiary),
            _StatData(
              'Response Rate',
              'प्रतिक्रिया दर',
              '94%',
              AppColors.secondary,
            ),
          ]
        : [
            _StatData('Pending', 'लंबित', '04', AppColors.secondaryContainer),
            _StatData('Resolved', 'समाधान', '12', AppColors.tertiaryFixed),
          ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 24),
      child: Row(
        children: stats
            .map(
              (s) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: stats.last == s
                        ? 0
                        : isDesktop
                        ? 24
                        : 16,
                  ),
                  padding: EdgeInsets.all(isDesktop ? 28 : 20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(isDesktop ? 12 : 16),
                    border: isDesktop
                        ? Border(
                            bottom: BorderSide(
                              color: s.accent.withValues(alpha: 0.3),
                              width: 4,
                            ),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.label.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: isDesktop ? 12 : 10,
                          fontWeight: FontWeight.w700,
                          color: isDesktop
                              ? s.accent
                              : AppColors.onSurfaceVariant,
                          letterSpacing: 1.5,
                        ),
                      ),
                      if (isDesktop) ...[
                        const SizedBox(height: 2),
                        Text(
                          s.hindiLabel,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      SizedBox(height: isDesktop ? 12 : 8),
                      Text(
                        s.value,
                        style: GoogleFonts.publicSans(
                          fontSize: isDesktop ? 42 : 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _requestsSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR REQUESTS',
                    style: GoogleFonts.publicSans(
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                      letterSpacing: isDesktop ? -0.5 : 0,
                    ),
                  ),
                  if (isDesktop)
                    Text(
                      'आपके अनुरोध',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._sampleRequests.map(
            (r) => isDesktop ? _desktopRequestRow(r) : _mobileRequestCard(r),
          ),
        ],
      ),
    );
  }

  Widget _mobileRequestCard(_RequestData r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r.title,
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.onSurface,
                ),
              ),
              _statusBadge(r.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            r.category,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: r.progress,
              minHeight: 4,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(r.progressColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopRequestRow(_RequestData r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  r.category,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ...List.generate(
                  4,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < (r.progress * 4).round()
                          ? r.progressColor
                          : AppColors.surfaceContainerHighest,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _statusBadge(r.status),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'In Progress':
        bg = AppColors.secondaryContainer;
        fg = AppColors.onSecondaryContainer;
        break;
      case 'Resolved':
        bg = AppColors.tertiaryFixed;
        fg = AppColors.onTertiaryFixed;
        break;
      default:
        bg = AppColors.surfaceContainerHighest;
        fg = AppColors.onSurfaceVariant;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: fg,
        ),
      ),
    );
  }

  Widget _supportBanner() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEED ASSISTANCE?',
                  style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'सहायता चाहिए?',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.contact_support, size: 18),
                    label: Text(
                      'Contact Support',
                      style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _neighborhoodPulse() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryContainer],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'NEIGHBORHOOD',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSecondaryContainer,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Neighbourhood\nPulse',
              style: GoogleFonts.publicSans(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'See what\'s happening around you.',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  static final _sampleRequests = [
    _RequestData(
      'Water Pipeline Issue',
      'Public Utilities',
      'In Progress',
      0.6,
      AppColors.secondaryContainer,
    ),
    _RequestData(
      'Road Repair Request',
      'Civil Infrastructure',
      'In Progress',
      0.3,
      AppColors.primary,
    ),
    _RequestData(
      'Noise Pollution Report',
      'Sanitation & Environment',
      'Resolved',
      1.0,
      AppColors.tertiary,
    ),
  ];
}

class _StatData {
  final String label;
  final String hindiLabel;
  final String value;
  final Color accent;
  const _StatData(this.label, this.hindiLabel, this.value, this.accent);
}

class _RequestData {
  final String title;
  final String category;
  final String status;
  final double progress;
  final Color progressColor;
  const _RequestData(
    this.title,
    this.category,
    this.status,
    this.progress,
    this.progressColor,
  );
}
