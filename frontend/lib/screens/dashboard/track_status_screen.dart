import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_bottom_nav.dart';
import '../../widgets/civic_footer.dart';
import '../../widgets/civic_side_nav.dart';

class TrackStatusScreen extends StatefulWidget {
  const TrackStatusScreen({super.key});

  @override
  State<TrackStatusScreen> createState() => _TrackStatusScreenState();
}

class _TrackStatusScreenState extends State<TrackStatusScreen> {
  final Map<String, bool> _feedbackExpanded = {};
  final Map<String, TextEditingController> _feedbackControllers = {};

  final List<({String id, String title, String status, Color tone})> _items = [
    (
      id: 'CP-2026-00142',
      title: 'Streetlight outage near Sector 5',
      status: 'In Progress',
      tone: AppColors.secondary,
    ),
    (
      id: 'CP-2026-00118',
      title: 'Water leakage on Main Road',
      status: 'Assigned',
      tone: AppColors.primary,
    ),
    (
      id: 'CP-2026-00097',
      title: 'Garbage pickup delay',
      status: 'Resolved',
      tone: AppColors.tertiary,
    ),
  ];

  @override
  void dispose() {
    for (final controller in _feedbackControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleFeedback(String complaintId) {
    setState(() {
      _feedbackExpanded[complaintId] =
          !(_feedbackExpanded[complaintId] ?? false);
    });
  }

  TextEditingController _controllerFor(String complaintId) {
    return _feedbackControllers.putIfAbsent(
      complaintId,
      TextEditingController.new,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: isDesktop
          ? null
          : CivicBottomNav(
              activeIndex: 2,
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

  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        const CivicSideNav(variant: 'citizen', activeIndex: 2),
        Expanded(
          child: Column(
            children: [
              const CivicAppBar(showAvatar: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1024),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(),
                          const SizedBox(height: 24),
                          _searchPanel(),
                          const SizedBox(height: 24),
                          _statusList(),
                          const SizedBox(height: 40),
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

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        const CivicAppBar(showMenuIcon: true, showAvatar: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 20),
                _searchPanel(),
                const SizedBox(height: 20),
                _statusList(),
                const SizedBox(height: 24),
                const CivicFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track Status',
          style: GoogleFonts.publicSans(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monitor your complaint progress in real time.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _searchPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search by complaint ID',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: 'e.g. CP-2026-00142',
              filled: true,
              fillColor: AppColors.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusList() {
    return Column(
      children: _items
          .map(
            (item) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.id,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: item.tone.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.status,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: item.tone,
                              ),
                            ),
                          ),
                          if (item.status == 'Resolved') ...[
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () => _toggleFeedback(item.id),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 34),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ),
                                side: BorderSide(
                                  color: item.tone.withValues(alpha: 0.35),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                (_feedbackExpanded[item.id] ?? false)
                                    ? 'Hide Feedback'
                                    : 'Feedback',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: item.tone,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  if (item.status == 'Resolved' &&
                      (_feedbackExpanded[item.id] ?? false)) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share your feedback (up to 250 characters)',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _controllerFor(item.id),
                            maxLength: 250,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText:
                                  'Tell us about your experience with the resolution...',
                              filled: true,
                              fillColor: AppColors.surfaceContainerHighest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(12),
                              counterStyle: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
