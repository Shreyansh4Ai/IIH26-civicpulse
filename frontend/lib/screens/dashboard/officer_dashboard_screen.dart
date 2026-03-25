import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_bottom_nav.dart';
import '../../widgets/civic_footer.dart';
import '../../widgets/civic_side_nav.dart';

/// Officer Dashboard — responsive mobile + desktop.
class OfficerDashboardScreen extends StatelessWidget {
  const OfficerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: isDesktop
          ? null
          : const CivicBottomNav(activeIndex: 0),
      body: isDesktop ? _desktopLayout(context) : _mobileLayout(context),
    );
  }

  // ─── DESKTOP ───
  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        const CivicSideNav(variant: 'officer', activeIndex: 0),
        Expanded(
          child: Column(
            children: [
              CivicAppBar(
                navLinks: const ['About Us', 'Contact Us', 'Dashboard'],
                showAvatar: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1024),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _heroSection(true),
                              const SizedBox(height: 48),
                              _metricsGrid(),
                              const SizedBox(height: 48),
                              _mainContent(true),
                            ],
                          ),
                        ),
                      ),
                      // Map Section
                      _mapSection(),
                      const SizedBox(height: 48),
                      const CivicFooter(),
                    ],
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
                _heroSection(false),
                _mobileStats(),
                const SizedBox(height: 24),
                _mobileComplaintCards(),
                const SizedBox(height: 24),
                const CivicFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _heroSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isDesktop) const SizedBox(height: 8),
          Text(
            isDesktop ? 'Welcome, Officer.' : 'Dashboard',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 48 : 36,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              height: 1.1,
              letterSpacing: isDesktop ? -1 : -0.5,
            ),
          ),
          if (isDesktop) ...[
            Text(
              'अधिकारी महोदय, स्वागत है।',
              style: GoogleFonts.publicSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                'Overview of the district\'s current infrastructure and citizen health reports. Actions required for 12 pending escalations.',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  color: AppColors.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              'Active Duty Overview',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── DESKTOP: 4-col metrics ───
  Widget _metricsGrid() {
    final metrics = [
      _Metric('Total Complaints', 'कुल शिकायतें', '1,284', AppColors.primary),
      _Metric('Pending Review', 'समीक्षा लंबित', '42', AppColors.error),
      _Metric('Resolved', 'समाधान किया गया', '912', AppColors.tertiary),
      _Metric('Avg. Resolution', 'औसत समाधान समय', '3.4d', AppColors.secondary),
    ];
    return Row(
      children: metrics
          .map(
            (m) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: m == metrics.last ? 0 : 24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    bottom: BorderSide(
                      color: m.accent.withValues(alpha: 0.2),
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.label.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: m.accent,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m.hindiLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      m.value,
                      style: GoogleFonts.publicSans(
                        fontSize: 42,
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
    );
  }

  // ─── DESKTOP: 3-col layout (queue 2/3 + insights 1/3) ───
  Widget _mainContent(bool isDesktop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Queue (2/3)
        Expanded(
          flex: 2,
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
                        'ACTIVE QUEUE',
                        style: GoogleFonts.publicSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'सक्रिय कतार - Real-time submissions',
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
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _complaintTable(),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Insights (1/3)
        Expanded(
          child: Column(
            children: [
              _categoryInsights(),
              const SizedBox(height: 32),
              _criticalActions(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _complaintTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _tableHeader('Complaint / शिकायत', flex: 3),
                _tableHeader('Priority / प्राथमिकता', flex: 2),
                _tableHeader('Area / क्षेत्र', flex: 2),
                _tableHeader('Status / स्थिति', flex: 2),
              ],
            ),
          ),
          ..._sampleComplaints.map(
            (c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.surfaceContainerLow,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          c.category,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: _priorityBadge(c.priority)),
                  Expanded(
                    flex: 2,
                    child: Text(
                      c.area,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.statusColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            c.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    Color bg;
    Color fg;
    switch (priority) {
      case 'High':
        bg = AppColors.errorContainer;
        fg = AppColors.onErrorContainer;
        break;
      case 'Low':
        bg = AppColors.tertiaryFixed;
        fg = AppColors.onTertiaryFixedVariant;
        break;
      default:
        bg = AppColors.surfaceContainerHighest;
        fg = AppColors.onSurfaceVariant;
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          priority.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: fg,
          ),
        ),
      ),
    );
  }

  Widget _categoryInsights() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CATEGORY INSIGHTS',
            style: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            'श्रेणी अंतर्दृष्टि',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _insightBar('Potholes (40%)', '512 Cases', 0.4, AppColors.primary),
          const SizedBox(height: 16),
          _insightBar(
            'Sewage (30%)',
            '385 Cases',
            0.3,
            AppColors.primaryContainer,
          ),
          const SizedBox(height: 16),
          _insightBar(
            'Electricity (20%)',
            '256 Cases',
            0.2,
            AppColors.outlineVariant,
          ),
          const SizedBox(height: 16),
          _insightBar('Others (10%)', '131 Cases', 0.1, AppColors.surfaceDim),
        ],
      ),
    );
  }

  Widget _insightBar(String label, String cases, double value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              cases,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 12,
            backgroundColor: AppColors.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _criticalActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CRITICAL ACTIONS',
          style: GoogleFonts.publicSans(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _actionButton(
          'Generate Report',
          'रिपोर्ट तैयार करें',
          Icons.description,
          AppColors.surfaceContainerLowest,
          AppColors.primary,
        ),
        const SizedBox(height: 12),
        _actionButton(
          'Dispatch Field Team',
          'फील्ड टीम भेजें',
          Icons.engineering,
          AppColors.surfaceContainerLowest,
          AppColors.secondary,
        ),
        const SizedBox(height: 12),
        _actionButton(
          'Emergency Alert',
          'आपातकालीन अलर्ट',
          Icons.emergency,
          AppColors.errorContainer,
          AppColors.error,
        ),
      ],
    );
  }

  Widget _actionButton(
    String label,
    String hindiLabel,
    IconData icon,
    Color bg,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accent, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                hindiLabel,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Icon(icon, color: accent, size: 22),
        ],
      ),
    );
  }

  Widget _mapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Colors.transparent],
          ),
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'LIVE INSIGHT',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSecondary,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'District Connectivity\nHotspots',
              style: GoogleFonts.publicSans(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Text(
                'Most reported issues are concentrated in the industrial corridor.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Launch GIS View',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── MOBILE: Bento Stats ───
  Widget _mobileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _mobileStat('Active Duty', '14', AppColors.primary)),
          const SizedBox(width: 16),
          Expanded(child: _mobileStat('Resolution', '89%', AppColors.tertiary)),
          const SizedBox(width: 16),
          Expanded(
            child: _mobileStat('Avg Response', '4.2h', AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _mobileStat(String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: accent,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.publicSans(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // ─── MOBILE: Complaint Cards ───
  Widget _mobileComplaintCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVE QUEUE',
                style: GoogleFonts.publicSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
              Row(
                children: [
                  Text(
                    'All',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._sampleComplaints.map(
            (c) => Container(
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
                        c.title,
                        style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.onSurface,
                        ),
                      ),
                      _priorityBadge(c.priority),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${c.category} · ${c.area}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.statusColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        c.status,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static final _sampleComplaints = [
    _ComplaintData(
      'Main Road Pothole',
      'Civil Infrastructure',
      'Sector 12-B',
      'High',
      'In Progress',
      AppColors.secondaryContainer,
    ),
    _ComplaintData(
      'Street Light Failure',
      'Electricity',
      'Park Avenue',
      'Medium',
      'New Submission',
      AppColors.outlineVariant,
    ),
    _ComplaintData(
      'Garbage Accumulation',
      'Sanitation',
      'Green Valley',
      'Low',
      'Resolved',
      AppColors.tertiary,
    ),
  ];
}

class _Metric {
  final String label;
  final String hindiLabel;
  final String value;
  final Color accent;
  const _Metric(this.label, this.hindiLabel, this.value, this.accent);
}

class _ComplaintData {
  final String title;
  final String category;
  final String area;
  final String priority;
  final String status;
  final Color statusColor;
  const _ComplaintData(
    this.title,
    this.category,
    this.area,
    this.priority,
    this.status,
    this.statusColor,
  );
}
