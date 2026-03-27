import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';
import '../../widgets/civic_side_nav.dart';
import '../../utils/global_state.dart';

class OfficerDispatchScreen extends StatefulWidget {
  const OfficerDispatchScreen({super.key});

  @override
  State<OfficerDispatchScreen> createState() => _OfficerDispatchScreenState();
}

class _OfficerDispatchScreenState extends State<OfficerDispatchScreen> {
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _getPendingIncidents() {
    // Combine standard mock incidents with the ones injected by AI 
    final aiItems = GlobalState.mockComplaints.map((c) => {
      'id': c['id'],
      'title': c['title'],
      'department': c['department'] ?? 'Unassigned',
      'priority': 'High',
      'time': 'Just now',
    }).toList();

    return [
      ...aiItems,
      {
        'id': 'CP-2026-00142',
        'title': 'Streetlight outage near Sector 5',
        'department': 'Electricity Board',
        'priority': 'Medium',
        'time': '2h ago',
      },
      {
        'id': 'CP-2026-00118',
        'title': 'Water leakage on Main Road',
        'department': 'Water/Sewage Authority (WSA)',
        'priority': 'High',
        'time': '4h ago',
      },
      {
        'id': 'CP-2026-00088',
        'title': 'Fallen tree blocking traffic',
        'department': 'Public Works Dept (PWD)',
        'priority': 'Critical',
        'time': '5h ago',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.onSurface),
              title: Text(
                'Dispatch Portal',
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ),
      drawer: isDesktop
          ? null
          : const Drawer(
              child: CivicSideNav(variant: 'officer', activeIndex: 1), // 1 is Complaints/Dispatch
            ),
      body: isDesktop ? _desktopLayout(context) : _mobileLayout(context),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Side Nav
        const CivicSideNav(variant: 'officer', activeIndex: 1),
        Expanded(
          child: Column(
            children: [
              const CivicAppBar(
                navLinks: ['Dashboard', 'Map View', 'System Logs'],
                showAvatar: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _headerSection(),
                              const SizedBox(height: 32),
                              _dispatchInterface(context),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 64),
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

  Widget _mobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerSection(),
                const SizedBox(height: 24),
                _dispatchInterface(context),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const CivicFooter(),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Operations & Dispatch',
              style: GoogleFonts.publicSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Assign units, update priorities, and monitor live responses.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (ResponsiveHelper.isDesktop(context))
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.download),
            label: const Text('Export Roster'),
          ),
      ],
    );
  }

  Widget _dispatchInterface(BuildContext context) {
    final incidents = _getPendingIncidents();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toolbar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search incident ID...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filters'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Data List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: incidents.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final incident = incidents[index];
              return _incidentRow(incident);
            },
          ),
        ],
      ),
    );
  }

  Widget _incidentRow(Map<String, dynamic> incident) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final priorityColor = _getPriorityColor(incident['priority']);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Status Indicator
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: priorityColor,
            ),
          ),
          const SizedBox(width: 16),
          // Main Info
          Expanded(
            flex: isDesktop ? 2 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incident['id'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  incident['title'],
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  incident['time'],
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Assigned Dept.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.corporate_fare, size: 16, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        incident['department'],
                        style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  incident['priority'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: priorityColor,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(width: 16),
          // Action Button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Force dispatched to ${incident['department']}'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Dispatch'),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'Critical') return AppColors.error;
    if (priority == 'High') return Colors.orange;
    if (priority == 'Medium') return AppColors.secondary;
    return AppColors.tertiary;
  }
}
