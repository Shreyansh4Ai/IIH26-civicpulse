import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/global_state.dart';

/// Side navigation rail for desktop dashboard views.
/// [variant] controls which nav items appear: 'citizen' or 'officer'.
class CivicSideNav extends StatelessWidget {
  const CivicSideNav({super.key, required this.variant, this.activeIndex = 0});

  final String variant; // 'citizen' | 'officer'
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final isOfficer = variant == 'officer';
    final items = isOfficer ? _officerItems : _citizenItems;

    return Container(
      width: 256,
      color: AppColors.surfaceContainerLow,
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Branding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (isOfficer)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                if (isOfficer) const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOfficer ? 'Officer Portal' : 'Civic Pulse',
                      style: GoogleFonts.publicSans(
                        fontSize: isOfficer ? 18 : 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      isOfficer ? 'District Governance' : 'Citizen Portal',
                      style: GoogleFonts.publicSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Nav Items
          ...items.asMap().entries.map(
            (e) => _navItem(
              e.value.$1,
              e.value.$2,
              context,
              variant,
              isActive: e.key == activeIndex,
            ),
          ),
          const SizedBox(height: 32),
          // Primary CTA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (!isOfficer) {
                    Navigator.pushNamed(context, '/register-complaint');                  } else {
                    Navigator.pushReplacementNamed(context, '/officer-dispatch');
                  }
                },
                icon: Icon(isOfficer ? Icons.add_task : Icons.add, size: 20),
                label: Text(
                  isOfficer ? 'New Dispatch' : 'New Request',
                  style: GoogleFonts.publicSans(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryContainer,
                  foregroundColor: AppColors.onSecondaryContainer,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Bottom links
          if (isOfficer) ...[
            _navItem(
              Icons.help,
              'Help Center',
              context,
              variant,
              isActive: false,
            ),
            _navItem(
              Icons.logout,
              'Logout',
              context,
              variant,
              isActive: false,
              isDestructive: true,
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static final _citizenItems = <(IconData, String)>[
    (Icons.dashboard, 'Dashboard'),
    (Icons.edit_document, 'File Complaint'),
    (Icons.analytics, 'Track Status'),
  ];

  static final _officerItems = <(IconData, String)>[
    (Icons.dashboard, 'Dashboard'),
    (Icons.assignment_late, 'Complaints'),
    (Icons.bar_chart, 'Analytics'),
    (Icons.admin_panel_settings, 'Access Control'),
    (Icons.inventory_2, 'Archive'),
  ];

  Widget _navItem(
    IconData icon,
    String label,
    BuildContext context,
    String variant, {
    bool isActive = false,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.error
        : isActive
        ? Colors.white
        : AppColors.onSurface;
    return Container(
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          label,
          style: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        onTap: () {
          if (variant == 'citizen') {
            if (label == 'Dashboard') {
              Navigator.pushReplacementNamed(context, '/citizen-dashboard');      
            } else if (label == 'File Complaint') {
              Navigator.pushReplacementNamed(context, '/register-complaint');     
            } else if (label == 'Track Status') {
              Navigator.pushReplacementNamed(context, '/track-status');
            }
          } else {
            // Officer Logic
            if (label == 'Dashboard') {
              Navigator.pushReplacementNamed(context, '/officer-dashboard');            } else if (label == 'Complaints' || label == 'New Dispatch') {
              Navigator.pushReplacementNamed(context, '/officer-dispatch');            } else if (label == 'Analytics') {
              Navigator.pushReplacementNamed(context, '/officer-analytics');
            } else if (label == 'Access Control') {
              Navigator.pushReplacementNamed(context, '/officer-access');
            } else if (label == 'Archive') {
              Navigator.pushReplacementNamed(context, '/officer-archive');
            } else if (label == 'Help Center') {
              Navigator.pushReplacementNamed(context, '/help-faq');
            } else if (label == 'Logout') {
              GlobalState.isOfficer = false;
              Navigator.pushReplacementNamed(context, '/'); // Return to login
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening $label...')),
              );
            }
          }
        },
      ),
    );
  }
}
