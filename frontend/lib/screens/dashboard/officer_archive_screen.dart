import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';
import '../../widgets/civic_side_nav.dart';

class OfficerArchiveScreen extends StatelessWidget {
  const OfficerArchiveScreen({super.key});

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
                'Archive',
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ),
      drawer: isDesktop
          ? null
          : const Drawer(
              child: CivicSideNav(variant: 'officer', activeIndex: 4), // 4 is Archive
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) const CivicSideNav(variant: 'officer', activeIndex: 4),
          Expanded(
            child: Column(
              children: [
                if (isDesktop) const CivicAppBar(navLinks: ['Dashboard', 'Map View', 'System Logs'], showAvatar: true),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Historical Records',
                            style: GoogleFonts.publicSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 100),
                              child: Text(
                                'Historical Complaints & Dispatch Logs Archive (Placeholder)',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
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
}
